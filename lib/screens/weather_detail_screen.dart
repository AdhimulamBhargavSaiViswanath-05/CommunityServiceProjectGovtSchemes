import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myscheme_app/providers/weather_provider.dart';

class WeatherDetailScreen extends StatelessWidget {
  const WeatherDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.weather;

    return Scaffold(
      appBar: AppBar(title: const Text('Weather Details')),
      body: weather == null
          ? const Center(child: Text('No weather data available.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather in ${weather.city}, ${weather.country}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'http://openweathermap.org/img/wn/${weather.icon}@4x.png',
                        errorBuilder: (c, o, s) =>
                            const Icon(Icons.cloud_off, size: 64),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '${weather.temperature.round()}°C',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      weather.description,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
