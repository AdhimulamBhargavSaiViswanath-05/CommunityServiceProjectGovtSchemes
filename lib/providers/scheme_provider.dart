import 'package:flutter/foundation.dart';
import 'package:myscheme_app/models/scheme.dart';
import 'package:myscheme_app/services/backend_api_service.dart';
import 'package:myscheme_app/utils/mock_data.dart';

class SchemeProvider with ChangeNotifier {
  final BackendApiService _apiService = BackendApiService();

  List<Scheme> _schemes = [];
  List<Scheme> get schemes => _schemes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isDemoMode = false;
  bool get isDemoMode => _isDemoMode;

  Future<void> fetchSchemes() async {
    _isLoading = true;
    _errorMessage = '';
    _isDemoMode = false;
    notifyListeners();

    try {
      // Check backend health first
      final isHealthy = await _apiService.isBackendHealthy();
      if (!isHealthy) {
        throw Exception('Backend not running. Start: python backend/server.py');
      }

      // Fetch schemes from backend
      _schemes = await _apiService.fetchAllSchemes(limit: 20);
      if (_schemes.isEmpty) {
        throw Exception('No schemes found from backend.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch schemes from backend: $e');
        print('Loading mock data as a fallback.');
      }
      _errorMessage = 'Backend unavailable. Displaying demo schemes.';
      _schemes = mockSchemes; // Fallback to mock data
      _isDemoMode = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
