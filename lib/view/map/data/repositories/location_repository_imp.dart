import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay/view/map/domain/repositories/location_repo.dart';



class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  @override
  Future<LatLng?> getCurrentLocation() async {
    try {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  @override
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  @override
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
