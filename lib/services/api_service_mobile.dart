import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myscheme_app/models/scheme.dart';
import 'package:myscheme_app/utils/constants.dart';

class ApiService {
  Future<List<Scheme>> fetchSchemes() async {
    int proxyIndex = 0;
    while (proxyIndex < corsProxies.length) {
      final String proxyUrl = corsProxies[proxyIndex];
      final String finalUrl = proxyUrl.isNotEmpty
          ? "$proxyUrl${Uri.encodeFull(baseUrl)}"
          : baseUrl;

      try {
        debugPrint("Attempting to fetch from (mobile): $finalUrl");
        final response = await http
            .get(Uri.parse(finalUrl), headers: getHeaders(proxyIndex))
            .timeout(const Duration(seconds: 20));

        if (response.statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          if (data is Map<String, dynamic> && data.containsKey('schemes')) {
            final List<dynamic> schemeList = data['schemes'];
            return schemeList.map((json) => Scheme.fromJson(json)).toList();
          } else {
            throw Exception(
              'Could not find a list of schemes in the response.',
            );
          }
        } else {
          debugPrint("Failed with status code: ${response.statusCode}");
          proxyIndex++;
        }
      } catch (e) {
        debugPrint("Error fetching schemes on mobile: $e");
        proxyIndex++;
      }
    }
    throw Exception('Failed to load schemes from all sources');
  }
}
