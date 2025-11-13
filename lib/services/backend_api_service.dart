import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/scheme.dart';

/// Backend API Service - Connects to Python Flask backend
/// This solves CORS issues by using Python as a proxy server
class BackendApiService {
  static const String backendUrl = 'http://localhost:5000';

  /// Check if backend server is running
  Future<bool> isBackendHealthy() async {
    try {
      final response = await http
          .get(
            Uri.parse('$backendUrl/health'),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('✅ Backend healthy: ${data['message']}');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Backend not reachable: $e');
      return false;
    }
  }

  /// Fetch all scheme slugs (paginated)
  Future<Map<String, dynamic>?> fetchSchemeSlugs({
    int fromIndex = 0,
    int size = 100,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '$backendUrl/api/schemes?from_index=$fromIndex&size=$size'),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      debugPrint('❌ Failed to fetch slugs: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('❌ Error fetching slugs: $e');
      return null;
    }
  }

  /// Fetch detailed scheme by slug
  Future<Scheme?> fetchSchemeBySlug(String slug) async {
    try {
      final response = await http
          .get(
            Uri.parse('$backendUrl/api/scheme/$slug'),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseScheme(data);
      }
      debugPrint('❌ Failed to fetch scheme $slug: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('❌ Error fetching scheme $slug: $e');
      return null;
    }
  }

  /// Fetch multiple schemes at once
  Future<List<Scheme>> fetchSchemesBatch(List<String> slugs) async {
    try {
      final response = await http
          .post(
            Uri.parse('$backendUrl/api/schemes/batch'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'slugs': slugs}),
          )
          .timeout(const Duration(minutes: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List schemes = data['schemes'] ?? [];
        return schemes.map((json) => _parseScheme(json)).toList();
      }
      debugPrint('❌ Failed to fetch batch: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching batch: $e');
      return [];
    }
  }

  /// Fetch all schemes (recommended approach)
  /// First gets all slugs, then fetches first batch of schemes
  Future<List<Scheme>> fetchAllSchemes({int limit = 10}) async {
    try {
      // Step 1: Check backend health
      final isHealthy = await isBackendHealthy();
      if (!isHealthy) {
        debugPrint(
            '⚠️ Backend not running. Start it with: python backend/server.py');
        return [];
      }

      // Step 2: Fetch slugs
      debugPrint('📡 Fetching scheme slugs...');
      final slugsData = await fetchSchemeSlugs(size: limit);
      if (slugsData == null) return [];

      final List<String> slugs = List<String>.from(slugsData['slugs'] ?? []);
      final int total = slugsData['total'] ?? 0;

      debugPrint('✅ Found ${slugs.length} slugs (total available: $total)');

      if (slugs.isEmpty) return [];

      // Step 3: Fetch scheme details in batch
      debugPrint('📡 Fetching scheme details...');
      final schemes = await fetchSchemesBatch(slugs);

      debugPrint('✅ Loaded ${schemes.length} schemes');
      return schemes;
    } catch (e) {
      debugPrint('❌ Error in fetchAllSchemes: $e');
      return [];
    }
  }

  /// Parse scheme from JSON (with all detailed fields)
  Scheme _parseScheme(Map<String, dynamic> json) {
    return Scheme.fromJson(json);
  }
}
