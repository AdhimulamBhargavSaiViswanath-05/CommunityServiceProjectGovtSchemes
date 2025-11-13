import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      if (kDebugMode) {
        print("Error getting current position: $e");
      }
      // On web, if it fails, try getting a less accurate position.
      if (kIsWeb) {
        try {
          return await Geolocator.getLastKnownPosition() ??
              Future.error('Could not get current or last known position.');
        } catch (e2) {
          if (kDebugMode) {
            print("Error getting last known position: $e2");
          }
          return Future.error(
            'Failed to get location. Please ensure location is enabled in your browser and try again.',
          );
        }
      }
      return Future.error(
        'Failed to get location. Please ensure your GPS is enabled and try again.',
      );
    }
  }
}
