import 'package:flutter/material.dart';
import 'package:myscheme_app/models/user_profile.dart';
import 'package:myscheme_app/services/preferences_service.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile _profile = UserProfile.empty();
  final PreferencesService _prefsService = PreferencesService();
  bool _isLoading = false;

  UserProfile get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isProfileComplete => _profile.completionPercentage >= 80;
  bool get isReadyForAI => _profile.isReadyForRecommendations;

  /// Initialize and load profile
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadProfile();
    } catch (e) {
      debugPrint('Profile initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load profile from storage
  Future<void> _loadProfile() async {
    try {
      final prefs = await _prefsService.getPreferences();
      if (prefs != null && prefs.containsKey('userProfile')) {
        _profile = UserProfile.fromJson(prefs['userProfile']);
      }
    } catch (e) {
      debugPrint('Load profile error: $e');
    }
  }

  /// Save profile to storage
  Future<void> _saveProfile() async {
    try {
      final prefs = await _prefsService.getPreferences() ?? {};
      prefs['userProfile'] = _profile.toJson();
      await _prefsService.savePreferences(prefs);
    } catch (e) {
      debugPrint('Save profile error: $e');
    }
  }

  /// Update basic info
  Future<void> updateBasicInfo({
    required String name,
    required int age,
    required String gender,
  }) async {
    _profile = _profile.copyWith(
      name: name,
      age: age,
      gender: gender,
    );
    await _saveProfile();
    notifyListeners();
  }

  /// Update professional info
  Future<void> updateProfessionalInfo({
    required String occupation,
    required String education,
    required double annualIncome,
  }) async {
    _profile = _profile.copyWith(
      occupation: occupation,
      education: education,
      annualIncome: annualIncome,
    );
    await _saveProfile();
    notifyListeners();
  }

  /// Update location
  Future<void> updateLocation({
    required String state,
    required String district,
  }) async {
    _profile = _profile.copyWith(
      state: state,
      district: district,
    );
    await _saveProfile();
    notifyListeners();
  }

  /// Update category
  Future<void> updateCategory(String category) async {
    _profile = _profile.copyWith(category: category);
    await _saveProfile();
    notifyListeners();
  }

  /// Update documents
  Future<void> updateDocuments({
    bool? hasAadhar,
    bool? hasPAN,
    bool? hasIncomeCertificate,
    bool? hasBankAccount,
  }) async {
    _profile = _profile.copyWith(
      hasAadhar: hasAadhar ?? _profile.hasAadhar,
      hasPAN: hasPAN ?? _profile.hasPAN,
      hasIncomeCertificate:
          hasIncomeCertificate ?? _profile.hasIncomeCertificate,
      hasBankAccount: hasBankAccount ?? _profile.hasBankAccount,
    );
    await _saveProfile();
    notifyListeners();
  }

  /// Add document
  Future<void> addDocument(String documentName) async {
    final updatedDocs = List<String>.from(_profile.documents);
    if (!updatedDocs.contains(documentName)) {
      updatedDocs.add(documentName);
      _profile = _profile.copyWith(documents: updatedDocs);
      await _saveProfile();
      notifyListeners();
    }
  }

  /// Remove document
  Future<void> removeDocument(String documentName) async {
    final updatedDocs = List<String>.from(_profile.documents);
    updatedDocs.remove(documentName);
    _profile = _profile.copyWith(documents: updatedDocs);
    await _saveProfile();
    notifyListeners();
  }

  /// Add applied scheme
  Future<void> addAppliedScheme(String schemeId) async {
    final updatedApplied = List<String>.from(_profile.appliedSchemes);
    if (!updatedApplied.contains(schemeId)) {
      updatedApplied.add(schemeId);
      _profile = _profile.copyWith(appliedSchemes: updatedApplied);
      await _saveProfile();
      notifyListeners();
    }
  }

  /// Add saved scheme
  Future<void> addSavedScheme(String schemeId) async {
    final updatedSaved = List<String>.from(_profile.savedSchemes);
    if (!updatedSaved.contains(schemeId)) {
      updatedSaved.add(schemeId);
      _profile = _profile.copyWith(savedSchemes: updatedSaved);
      await _saveProfile();
      notifyListeners();
    }
  }

  /// Remove saved scheme
  Future<void> removeSavedScheme(String schemeId) async {
    final updatedSaved = List<String>.from(_profile.savedSchemes);
    updatedSaved.remove(schemeId);
    _profile = _profile.copyWith(savedSchemes: updatedSaved);
    await _saveProfile();
    notifyListeners();
  }

  /// Check if scheme is saved
  bool isSchemeSaved(String schemeId) {
    return _profile.savedSchemes.contains(schemeId);
  }

  /// Check if scheme is applied
  bool isSchemeApplied(String schemeId) {
    return _profile.appliedSchemes.contains(schemeId);
  }

  /// Update entire profile
  Future<void> updateProfile(UserProfile newProfile) async {
    _profile = newProfile;
    await _saveProfile();
    notifyListeners();
  }

  /// Reset profile
  Future<void> resetProfile() async {
    _profile = UserProfile.empty();
    await _saveProfile();
    notifyListeners();
  }

  /// Get completion percentage
  int getCompletionPercentage() {
    return _profile.completionPercentage;
  }

  /// Get missing fields
  List<String> getMissingFields() {
    final missing = <String>[];

    if (_profile.name.isEmpty) missing.add('Name');
    if (_profile.age == 0) missing.add('Age');
    if (_profile.gender.isEmpty) missing.add('Gender');
    if (_profile.occupation.isEmpty) missing.add('Occupation');
    if (_profile.education.isEmpty) missing.add('Education');
    if (_profile.annualIncome == 0) missing.add('Annual Income');
    if (_profile.state.isEmpty) missing.add('State');
    if (_profile.district.isEmpty) missing.add('District');
    if (_profile.category.isEmpty) missing.add('Category');
    if (!_profile.hasAadhar) missing.add('Aadhar Card');
    if (!_profile.hasPAN) missing.add('PAN Card');
    if (!_profile.hasIncomeCertificate) missing.add('Income Certificate');
    if (!_profile.hasBankAccount) missing.add('Bank Account');

    return missing;
  }
}
