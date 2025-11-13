import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myscheme_app/services/location_service.dart';
import 'package:myscheme_app/providers/weather_provider.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  Future<void> determinePosition(WeatherProvider weatherProvider) async {
    _errorMessage = '';
    _currentPosition = null;
    notifyListeners();
    try {
      _currentPosition = await _locationService.determinePosition();
      if (_currentPosition != null) {
        // Fetch weather immediately since we have coordinates
        await weatherProvider.fetchWeather(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('Error determining position: $_errorMessage');
      }
    }
    notifyListeners();
  }
}
