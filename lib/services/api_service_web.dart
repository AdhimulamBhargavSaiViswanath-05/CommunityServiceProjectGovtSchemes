import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myscheme_app/models/scheme.dart';
import 'package:myscheme_app/utils/constants.dart';

class ApiService {
  Future<List<Scheme>> fetchSchemes() async {
    // Try multiple proxies in sequence
    final proxies = [
      {
        'url': 'https://api.allorigins.win/raw?url=$baseUrl',
        'headers': <String, String>{
          'accept': 'application/json',
        }
      },
      {
        'url': 'https://corsproxy.io/?${Uri.encodeComponent(baseUrl)}',
        'headers': <String, String>{
          'accept': 'application/json',
        }
      },
      {
        'url': baseUrl,
        'headers': <String, String>{
          'x-api-key': apiKey,
          'accept': 'application/json',
          'origin': 'https://www.myscheme.gov.in',
        }
      },
    ];

    for (int i = 0; i < proxies.length; i++) {
      try {
        final proxy = proxies[i];
        debugPrint(
            "Attempting fetch (${i + 1}/${proxies.length}): ${proxy['url']}");

        final response = await http
            .get(
              Uri.parse(proxy['url'] as String),
              headers: proxy['headers'] as Map<String, String>,
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          debugPrint("✅ Successfully fetched data with proxy ${i + 1}");
          return _parseSchemes(response);
        } else {
          debugPrint(
              "❌ Proxy ${i + 1} failed with status: ${response.statusCode}");
        }
      } catch (e) {
        debugPrint("❌ Proxy ${i + 1} error: $e");
        if (i == proxies.length - 1) {
          // Last proxy failed
          throw Exception(
            'All proxies failed. Using demo data. Please check your network connection.',
          );
        }
      }
    }

    throw Exception('Failed to fetch schemes from all sources');
  }

  List<Scheme> _parseSchemes(http.Response response) {
    final data = json.decode(utf8.decode(response.bodyBytes));

    // Check if response contains error message
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      debugPrint('❌ API Error: ${data['message']}');
      throw Exception('API Error: ${data['message']}');
    }

    // Check for schemes list in response
    if (data is Map<String, dynamic> && data.containsKey('schemes')) {
      final List<dynamic> schemeList = data['schemes'];
      return schemeList.map((json) => Scheme.fromJson(json)).toList();
    }

    // Check if data is directly a list (some APIs return array directly)
    if (data is List) {
      return data.map((json) => Scheme.fromJson(json)).toList();
    }

    throw Exception(
        'API response did not contain valid scheme data. Received: ${data.runtimeType}');
  }
}
