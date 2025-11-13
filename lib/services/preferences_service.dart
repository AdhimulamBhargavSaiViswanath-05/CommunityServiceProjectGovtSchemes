import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferencesService {
  static const String _keyLanguage = 'language';
  static const String _keyNotifications = 'notifications';
  static const String _keyUserName = 'userName';
  static const String _keyUserAge = 'userAge';
  static const String _keySavedSchemes = 'savedSchemes';
  static const String _keyUserProfile = 'userProfile';
  static const String _keyPreferences = 'allPreferences';

  /// Get all preferences as Map
  Future<Map<String, dynamic>?> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyPreferences);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  /// Save all preferences
  Future<void> savePreferences(Map<String, dynamic> preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPreferences, json.encode(preferences));
  }

  /// Save user profile
  Future<void> saveUserProfile(Map<String, dynamic> profileData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserProfile, json.encode(profileData));
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyUserProfile);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, language);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'English';
  }

  // Alias methods for dynamic language provider
  Future<void> savePreferredLanguage(String language) async {
    await setLanguage(language);
  }

  Future<String?> getPreferredLanguage() async {
    final lang = await getLanguage();
    return lang == 'English' ? null : lang;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotifications) ?? true;
  }

  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? 'Guest';
  }

  Future<void> setUserAge(int age) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserAge, age);
  }

  Future<int?> getUserAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserAge);
  }

  Future<void> saveFavoriteScheme(String schemeId) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_keySavedSchemes) ?? [];
    if (!saved.contains(schemeId)) {
      saved.add(schemeId);
      await prefs.setStringList(_keySavedSchemes, saved);
    }
  }

  Future<void> removeFavoriteScheme(String schemeId) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_keySavedSchemes) ?? [];
    saved.remove(schemeId);
    await prefs.setStringList(_keySavedSchemes, saved);
  }

  Future<List<String>> getFavoriteSchemes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keySavedSchemes) ?? [];
  }

  Future<bool> isSchemesFavorite(String schemeId) async {
    final favorites = await getFavoriteSchemes();
    return favorites.contains(schemeId);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
