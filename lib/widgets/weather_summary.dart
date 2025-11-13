import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myscheme_app/providers/weather_provider.dart';
import 'package:myscheme_app/providers/location_provider.dart';

import 'package:myscheme_app/screens/weather_detail_screen.dart';

class WeatherSummary extends StatelessWidget {
  const WeatherSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    // The main onTap action
    void showWeatherDetails() {
      if (weatherProvider.weather != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WeatherDetailScreen()),
        );
      }
    }

    if (weatherProvider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.0),
        ),
      );
    }

    if (weatherProvider.hasError || weatherProvider.weather == null) {
      return Tooltip(
        message: "Tap to get location and weather",
        child: InkWell(
          onTap: () {
            // Manually trigger location/weather fetch if it failed or hasn't run
            final locationProvider = Provider.of<LocationProvider>(
              context,
              listen: false,
            );
            final weatherProvider = Provider.of<WeatherProvider>(
              context,
              listen: false,
            );
            locationProvider.determinePosition(weatherProvider);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.thermostat_auto_outlined, color: Colors.blue),
          ),
        ),
      );
    }

    final weather = weatherProvider.weather!;
    final double temperature = weather.temperature;
    final String description = weather.description;
    final String iconCode = weather.icon;
    final String iconUrl = 'http://openweathermap.org/img/wn/$iconCode@2x.png';

    return InkWell(
      onTap: showWeatherDetails,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isVerySmall = screenWidth < 340;

          return Padding(
            padding: EdgeInsets.all(isVerySmall ? 4.0 : 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  iconUrl,
                  width: isVerySmall ? 24 : 32,
                  height: isVerySmall ? 24 : 32,
                  errorBuilder: (c, o, s) => Icon(
                    Icons.cloud_off,
                    size: isVerySmall ? 24 : 32,
                  ),
                ),
                SizedBox(width: isVerySmall ? 3 : 6),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${temperature.round()}°C',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: isVerySmall ? 11 : 13,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: isVerySmall ? 9 : 11,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
