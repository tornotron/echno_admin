import 'package:geolocator/geolocator.dart';
import 'dart:developer' as devtools show log;

class LocationService {
  Position? currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  Future<Map<String, double>> getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      devtools.log('Location Service is not enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double currentLatitude = currentPosition.latitude;
    double currentLongitude = currentPosition.longitude;

    Map<String, double> location = {
      'latitude': currentLatitude,
      'longitude': currentLongitude,
    };
    return location;
  }

  Future<bool> isEmployeeWithinSite({
    required double siteLattitude,
    required double siteLongitude,
    required double currentLattitude,
    required double currentLongitude,
    required double siteRadius,
  }) async {
    // Calculate Distance
    final double distance = Geolocator.distanceBetween(
      currentLattitude,
      currentLongitude,
      siteLattitude,
      siteLongitude,
    );
    devtools.log('Distance: $distance');
    if (distance <= siteRadius) {
      devtools.log('You are in the range');
      return true;
    } else {
      devtools.log('You are not in the range');
      return false;
    }
  }
}
