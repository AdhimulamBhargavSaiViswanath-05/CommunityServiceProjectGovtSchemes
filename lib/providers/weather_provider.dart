import 'package:flutter/foundation.dart';
import 'package:myscheme_app/models/weather_model.dart';
import 'package:myscheme_app/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _weather;
  WeatherModel? get weather => _weather;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  Future<void> fetchWeather(double lat, double lon) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _weather = await _weatherService.fetchWeather(lat, lon);
    } catch (e) {
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('Error fetching weather: $_errorMessage');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
