import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myscheme_app/models/scheme.dart';
import 'package:myscheme_app/utils/constants.dart';

/// Improved API service with better error handling and retry logic
class ImprovedApiService {
  // Cache for schemes data
  static List<Scheme>? _cachedSchemes;
  static DateTime? _lastFetchTime;
  static const Duration _cacheValidDuration = Duration(hours: 1);

  /// Fetch schemes with caching and better error handling
  Future<List<Scheme>> fetchSchemes({bool forceRefresh = false}) async {
    // Return cached data if valid
    if (!forceRefresh &&
        _cachedSchemes != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheValidDuration) {
      debugPrint('✅ Using cached scheme data');
      return _cachedSchemes!;
    }

    // Try multiple strategies
    try {
      // Strategy 1: Try direct API with authentication
      final schemes = await _tryDirectAPI();
      _cacheSchemes(schemes);
      return schemes;
    } catch (e) {
      debugPrint('❌ Direct API failed: $e');

      try {
        // Strategy 2: Try CORS proxies
        final schemes = await _tryProxies();
        _cacheSchemes(schemes);
        return schemes;
      } catch (e) {
        debugPrint('❌ All proxies failed: $e');

        // Strategy 3: Use cached data if available
        if (_cachedSchemes != null) {
          debugPrint('⚠️ Using stale cached data');
          return _cachedSchemes!;
        }

        // Strategy 4: Fallback to demo data
        throw Exception('All sources failed. Using demo data.');
      }
    }
  }

  /// Try direct API call with proper authentication
  Future<List<Scheme>> _tryDirectAPI() async {
    debugPrint('🔄 Attempting direct API call...');

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'x-api-key': apiKey,
        'accept': 'application/json',
        'user-agent': 'MySchemeApp/1.0',
        'origin': 'https://www.myscheme.gov.in',
      },
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      debugPrint('✅ Direct API succeeded');
      return _parseSchemes(response);
    } else {
      throw Exception(
          'API returned status ${response.statusCode}: ${response.body}');
    }
  }

  /// Try CORS proxies in order
  Future<List<Scheme>> _tryProxies() async {
    final proxies = [
      {
        'name': 'AllOrigins',
        'url':
            'https://api.allorigins.win/get?url=${Uri.encodeComponent(baseUrl)}',
        'parseContents': true,
      },
      {
        'name': 'CORS Anywhere',
        'url': 'https://cors-anywhere.herokuapp.com/$baseUrl',
        'parseContents': false,
      },
      {
        'name': 'ThingProxy',
        'url': 'https://thingproxy.freeboard.io/fetch/$baseUrl',
        'parseContents': false,
      },
    ];

    for (final proxy in proxies) {
      try {
        debugPrint('🔄 Trying ${proxy['name']} proxy...');

        final response = await http.get(
          Uri.parse(proxy['url'] as String),
          headers: {'accept': 'application/json'},
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          debugPrint('✅ ${proxy['name']} proxy succeeded');

          // Parse based on proxy type
          if (proxy['parseContents'] == true) {
            // For AllOrigins, extract contents field
            final data = json.decode(response.body);
            final contents = data['contents'];
            final actualResponse = http.Response(
              contents,
              response.statusCode,
              headers: response.headers,
            );
            return _parseSchemes(actualResponse);
          } else {
            return _parseSchemes(response);
          }
        }
      } catch (e) {
        debugPrint('❌ ${proxy['name']} failed: $e');
        continue;
      }
    }

    throw Exception('All proxies failed');
  }

  /// Parse schemes from response
  List<Scheme> _parseSchemes(http.Response response) {
    final data = json.decode(utf8.decode(response.bodyBytes));

    // Handle error responses
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message') && data['message'] == 'Unauthorized') {
        throw Exception('API authentication failed - invalid or expired key');
      }

      if (data.containsKey('error')) {
        throw Exception('API error: ${data['error']}');
      }

      // Extract schemes array
      if (data.containsKey('schemes') && data['schemes'] is List) {
        final List<dynamic> schemeList = data['schemes'];
        return schemeList.map((json) => Scheme.fromJson(json)).toList();
      }
    }

    // Handle direct array response
    if (data is List) {
      return data.map((json) => Scheme.fromJson(json)).toList();
    }

    throw Exception('Invalid response format: ${data.runtimeType}');
  }

  /// Cache schemes data
  void _cacheSchemes(List<Scheme> schemes) {
    _cachedSchemes = schemes;
    _lastFetchTime = DateTime.now();
    debugPrint('💾 Cached ${schemes.length} schemes');
  }

  /// Clear cache
  static void clearCache() {
    _cachedSchemes = null;
    _lastFetchTime = null;
    debugPrint('🗑️ Cache cleared');
  }
}
