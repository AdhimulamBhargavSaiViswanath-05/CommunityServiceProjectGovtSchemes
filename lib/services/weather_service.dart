import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myscheme_app/models/weather_model.dart';
import 'package:myscheme_app/utils/constants.dart';

class WeatherService {
  Future<WeatherModel> fetchWeather(double lat, double lon,
      {int retries = 3}) async {
    final url =
        '${weatherBaseUrl}lat=$lat&lon=$lon&appid=$weatherApiKey&units=metric';

    for (int i = 0; i < retries; i++) {
      try {
        final response =
            await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          return WeatherModel.fromJson(jsonDecode(response.body));
        } else if (response.statusCode == 401) {
          throw Exception(
              'Invalid API key. Please check your weather API key.');
        } else if (response.statusCode == 404) {
          throw Exception('Location not found.');
        } else if (i == retries - 1) {
          // Last attempt failed
          throw Exception(
              'Failed to load weather data. Status: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // Last retry failed
          throw Exception('Network error: ${e.toString()}');
        }
        // Wait before retrying
        await Future.delayed(Duration(seconds: i + 1));
      }
    }

    throw Exception('Failed to load weather data after $retries attempts');
  }
}
