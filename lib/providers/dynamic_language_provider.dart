import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicLanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('dynamic_language') ?? 'en';
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dynamic_language', languageCode);
    notifyListeners();
  }

  // Supported languages
  List<Map<String, String>> get supportedLanguages => [
        {'code': 'en', 'name': 'English'},
        {'code': 'hi', 'name': 'हिंदी'},
        {'code': 'te', 'name': 'తెలుగు'},
        {'code': 'bn', 'name': 'বাংলা'},
        {'code': 'mr', 'name': 'मराठी'},
        {'code': 'ta', 'name': 'தமிழ்'},
      ];

  String getLanguageName(String code) {
    final language = supportedLanguages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'code': 'en', 'name': 'English'},
    );
    return language['name']!;
  }
}
