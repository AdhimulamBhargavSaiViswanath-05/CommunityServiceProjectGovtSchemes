import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Service for dynamic translation using Google Translate API
/// Free alternative: Uses MyMemory Translation API (no API key needed)
class TranslationService {
  // MyMemory Translation API (Free, 1000 requests/day per IP)
  static const String _myMemoryBaseUrl =
      'https://api.mymemory.translated.net/get';

  // Language codes
  static const Map<String, String> languageCodes = {
    'English': 'en',
    'Hindi': 'hi',
    'Tamil': 'ta',
    'Telugu': 'te',
    'Bengali': 'bn',
  };

  /// Translate text using MyMemory API (Free)
  /// Falls back to returning original text if translation fails
  static Future<String> translateText({
    required String text,
    required String targetLanguage,
    String sourceLanguage = 'en',
  }) async {
    try {
      // If target is English, return as-is
      if (targetLanguage == 'en' || targetLanguage == sourceLanguage) {
        return text;
      }

      final url = Uri.parse(_myMemoryBaseUrl).replace(queryParameters: {
        'q': text,
        'langpair': '$sourceLanguage|$targetLanguage',
      });

      final response = await http.get(url).timeout(
            const Duration(seconds: 5),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['responseStatus'] == 200) {
          final translatedText = data['responseData']['translatedText'];
          debugPrint('✅ Translated: "$text" → "$translatedText"');
          return translatedText;
        }
      }

      debugPrint('⚠️ Translation failed, using original text');
      return text;
    } catch (e) {
      debugPrint('❌ Translation error: $e');
      return text; // Fallback to original text
    }
  }

  /// Translate multiple texts in batch
  static Future<Map<String, String>> translateBatch({
    required List<String> texts,
    required String targetLanguage,
    String sourceLanguage = 'en',
  }) async {
    final Map<String, String> translations = {};

    for (final text in texts) {
      final translated = await translateText(
        text: text,
        targetLanguage: targetLanguage,
        sourceLanguage: sourceLanguage,
      );
      translations[text] = translated;

      // Small delay to avoid rate limiting
      await Future.delayed(const Duration(milliseconds: 100));
    }

    return translations;
  }

  /// Get translation for common app strings
  static Future<Map<String, String>> getCommonTranslations({
    required String targetLanguage,
  }) async {
    final commonStrings = [
      'Welcome',
      'Home',
      'Profile',
      'Schemes',
      'Search',
      'Loading',
      'Save',
      'Cancel',
      'Edit',
      'Delete',
      'Settings',
      'Language',
      'About',
      'Help',
      'Logout',
    ];

    return await translateBatch(
      texts: commonStrings,
      targetLanguage: languageCodes[targetLanguage] ?? 'en',
    );
  }
}
