import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_user/generated/assets.dart' show Assets;
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/theme/theme_controller.dart';
// ignore: unused_import
import 'package:rider_pay_user/view/firebase_service/ride/data/model/ride_booking_model.dart';
import 'package:rider_pay_user/view/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_user/view/map/data/repositories/map_repo_imp.dart';
import 'package:rider_pay_user/view/map/domain/repositories/location_repo.dart';
import 'package:rider_pay_user/view/map/presentation/controller/state/map_state.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';

class MapController extends StateNotifier<MapState> {
  final LocationRepository _repo;
  final Ref ref;

  MapController(this._repo, this.ref) : super(const MapState()) {
    ref.listen<ThemeMode>(themeModeProvider, (prev, next) async {
      await updateMapStyle(next);
    });

    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
          final currentTheme = ref.read(themeModeProvider);
          updateMapStyle(currentTheme);
        };
  }

  final Completer<GoogleMapController> completer = Completer();

  Future<void> updateMapStyle(ThemeMode mode) async {
    Brightness platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final effectiveDark =
        (mode == ThemeMode.dark) ||
        (mode == ThemeMode.system && platformBrightness == Brightness.dark);

    final stylePath = effectiveDark
        ? "assets/dark_mode_map.json"
        : "assets/light_mode_map.json";

    final style = await rootBundle.loadString(stylePath);

    if (completer.isCompleted) {
      try {
        final controller = await completer.future;
        // ignore: deprecated_member_use
        await controller.setMapStyle(style);
      } catch (e) {
      }
    }
  }

  static const String currentLocationText = "Your current location";

  Future<String> fetchCurrentLocation({
    LocationType? type = LocationType.pickup,
  }) async {
    state = state.copyWith(isLocationLoading: true);

    try {
      final hasPermission = await ref
          .read(locationServiceProvider.notifier)
          .ensurePermission();
      if (!hasPermission) {
        state = state.copyWith(isLocationLoading: false);
        return "";
      }

      final latLng = await _repo.getCurrentLocation();

      String address = MapController.currentLocationText;

      if (latLng != null) {
        if (type == LocationType.pickup) {
          state = state.copyWith(
            pickupLocation: latLng,
            pickupAddress: currentLocationText,
          );
        } else {
          state = state.copyWith(
            destinationLocation: latLng,
            destinationAddress: currentLocationText,
          );
        }
      }

      state = state.copyWith(isLocationLoading: false);
      return address;
    } catch (e) {
      debugPrint("Error fetching current location: $e");
      state = state.copyWith(isLocationLoading: false);
      return "";
    }
  }

  void setProcessing(bool value) {
    state = state.copyWith(isMapProcessing: value);
  }

  void clearPickup() {
    state = state.copyWith(pickupLocation: null, pickupAddress: "");


  }

  void clearDestination() {
    state = state.copyWith(destinationLocation: null, destinationAddress: "");
  }

  void updatePickup(LatLng latLng, String address) {
    state = state.copyWith(pickupLocation: latLng, pickupAddress: address);
  }

  void updateDestination(LatLng latLng, String address) {
    state = state.copyWith(
      destinationLocation: latLng,
      destinationAddress: address,
    );
  }

  Future<bool> selectLocationAndUpdateMap({
    required LocationType type,
    required LatLng latLng,
    String? address,
  }) async
  {
    state = state.copyWith(isMapProcessing: true);

    await setLocation(type: type, latLng: latLng, address: address);

    state = state.copyWith(isMapProcessing: false);

    if (state.pickupLocation != null &&
        state.destinationLocation != null &&
        state.pickupAddress != null &&
        state.pickupAddress!.isNotEmpty &&
        state.destinationAddress != null &&
        state.destinationAddress!.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> setLocation({
    required LocationType type,
    required LatLng latLng,
    String? address,
  }) async {
    final resolvedAddress = address ?? await getAddressFromLatLng(latLng);
    if (type == LocationType.pickup) {
      state = state.copyWith(
        pickupLocation: latLng,
        pickupAddress: resolvedAddress,
      );
    } else {
      state = state.copyWith(
        destinationLocation: latLng,
        destinationAddress: resolvedAddress,
      );
    }
  }

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      final placeMarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      final place = placeMarks.first;
      return "${place.name}, ${place.locality}, ${place.postalCode}";
    } catch (e) {
      debugPrint("Reverse geocode failed: $e");
      return "${latLng.latitude},${latLng.longitude}";
    }
  }

  Future<void> moveCamera(double lat, double lng, double zoom) async {
    final controller = await completer.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: zoom),
      ),
    );
  }

  Future<void> setPickupLatLng(LatLng value) async {
    state = state.copyWith(pickupLocation: value);
  }

  Future<void> setDestLatLng(LatLng value) async {
    state = state.copyWith(destinationLocation: value);
  }

  /// Reverse geocoding

  Future<BitmapDescriptor> resizeImage(String assetPath, int width) async {
    final byteData = await rootBundle.load(assetPath);
    final codec = await instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
    );
    final frame = await codec.getNextFrame();
    final data = await frame.image.toByteData(format: ImageByteFormat.png);
    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  /// Add marker
  Future<void> addMarker(
    LatLng position,
    String markerId,
    String assetPath, {
    int? markerHeight,
    String? title, // Address or label
    String? snippet, // Optional extra info
  }) async {
    try {
      final icon = await resizeImage(assetPath, markerHeight ?? 60);
      final marker = Marker(
        markerId: MarkerId(markerId),
        position: position,
        icon: icon,
        infoWindow: InfoWindow(
          title: title ?? "", // Show address
          snippet: snippet ?? "",
        ),
      );

      final updated = {...state.markers}
        ..removeWhere((m) => m.markerId.value == markerId);
      updated.add(marker);
      state = state.copyWith(markers: updated);
    } catch (e) {
      debugPrint("Marker error: $e");
    }
  }
 bool _pickupToDestinationDrawn =false;

  Future<void> listenToDriverMarker({
    required LatLng driverLatLng,
    required LatLng pickupLatLng,
    required String vehicleType,
  }) async
  {
    try {


      final currentRide= ref.read(rideNotifierProvider).currentRide;

      final carIcon = await resizeImage(Assets.iconCarMarkerYe, 60);
      final bikeIcon = await resizeImage(Assets.iconBikeMarker, 60);
      final autoIcon = await resizeImage(Assets.iconAutoMarker, 60);

      BitmapDescriptor driverIcon;
      if (vehicleType.toLowerCase() == "bike") {
        driverIcon = bikeIcon;
      } else if (vehicleType.toLowerCase() == "auto") {
        driverIcon = autoIcon;
      } else {
        driverIcon = carIcon;
      }

      final mapRepo = ref.read(mapRepositoryProvider);

      // Snap to road
      LatLng roadAlignedPos = await mapRepo.snapToRoad(driverLatLng);

      // Marker creation
      final existing = state.markers.firstWhere(
            (m) => m.markerId.value == "driver_marker",
        orElse: () => Marker(
          markerId: const MarkerId("driver_marker"),
          position: roadAlignedPos,
          icon: driverIcon,
        ),
      );

      if (state.markers.any((m) => m.markerId.value == "driver_marker")) {
        await _animateMarker(
          oldMarker: existing,
          newPosition: roadAlignedPos,
          markerId: "driver_marker",
          icon: driverIcon,
        );
      } else {
        state = state.copyWith(
          markers: {...state.markers, existing},
        );
      }
      final status = currentRide?.status.toLowerCase()??"cancelled";
      final isOtpVerified = status == "otp_verified";
      final isCompleted = status == "completed" && status == "cancelled";

      if (!_pickupToDestinationDrawn  && !isOtpVerified && !isCompleted) {
        _pickupToDestinationDrawn = true;
        await _drawDriverToPickupAnimated(
          driverLatLng: roadAlignedPos,
          pickupLatLng: pickupLatLng,
        );
        _startBlinkingDriverMarker(driverIcon, roadAlignedPos);

      }else if(!isOtpVerified && !isCompleted){
        await drawRoute(roadAlignedPos, pickupLatLng,shouldMakerAdd: false);

      }else if( isCompleted ){
        stopDriverAnimation();
      }

    } catch (e, st) {
      debugPrint("❌ listenToDriverMarker ERROR: $e\n$st");
    }
  }

  Future<void> _drawDriverToPickupAnimated({
    required LatLng driverLatLng,
    required LatLng pickupLatLng,
  }) async
  {
    try {
      final mapRepo = ref.read(mapRepositoryProvider);
      state = state.copyWith(isMapProcessing: true);

      final snappedDriver = await mapRepo.snapToRoad(driverLatLng);
      final snappedPickup = await mapRepo.snapToRoad(pickupLatLng);

      final data = await ref.read(mapNotifierProvider.notifier).drawRoutePolyline(snappedDriver, snappedPickup);

      final decodedPoints = await _getAccuratePolyline(data);

       await moveCamera(snappedPickup.latitude, snappedPickup.longitude, 14);

      // Animate growth
      List<LatLng> partial = [];
      const delay = Duration(milliseconds: 30);
      for (int i = 0; i < decodedPoints.length; i++) {
        partial.add(decodedPoints[i]);
        state = state.copyWith(polyline: {
          Polyline(
            polylineId: const PolylineId("route"),
            color: Colors.blue,
            width: 4,
            points: List.from(partial),
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          ),
        });
        await Future.delayed(delay);
      }

      await moveCameraOnPolyline(decodedPoints, snappedDriver);
      state = state.copyWith(isMapProcessing: false);
      debugPrint("✅ Animated route drawn (${decodedPoints.length} pts)");
    } catch (e) {
      state = state.copyWith(isMapProcessing: false);
      debugPrint("❌ Animated draw error: $e");
    }
  }

  Timer? _blinkTimer;
  void _startBlinkingDriverMarker(BitmapDescriptor icon, LatLng pos) {
    _blinkTimer?.cancel();
    bool visible = true;
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      visible = !visible;
      final marker = Marker(
        markerId: const MarkerId("driver_marker"),
        position: pos,
        icon: icon,
        alpha: visible ? 1.0 : 0.5,
      );

      state = state.copyWith(
        markers: {
          ...state.markers.where((m) => m.markerId.value != "driver_marker"),
          marker,
        },
      );
    });
  }
  void stopDriverAnimation() {
    _blinkTimer?.cancel();
    _blinkTimer = null;
    // _pickupToDestinationDrawn = false;
  }









  Future<void> updateAnimatedDriverMarkers(
    List<Map<String, dynamic>> drivers,
  ) async
  {
    final mapNo = ref.read(mapRepositoryProvider);
    final currentMarkers = Set<Marker>.from(state.markers);
    // Cache icons
    final carIcon = await resizeImage(Assets.iconCarMarkerYe, 50);
    final bikeIcon = await resizeImage(Assets.iconBikeMarker, 60);
    final autoIcon = await resizeImage(Assets.iconAutoMarker, 50);
    final cabIcon = await resizeImage(Assets.iconCabMarker, 60);

    final activeDriverIds = <String>{};
    // final random = Random();
    for (final driver in drivers) {
      final id = "driver_${driver["id"]}";
      activeDriverIds.add(id);
      final vehicleType = (driver["vehicleType"] ?? "").toString().toLowerCase();
      BitmapDescriptor driverIcon;
      if (vehicleType.toLowerCase() == "bike") {
        driverIcon = bikeIcon;
      } else if (vehicleType.toLowerCase() == "auto"|| vehicleType.toLowerCase() == "e-rickshaw") {
        driverIcon = autoIcon;
      }else if(vehicleType.toLowerCase()=="cab premium" ){
        driverIcon = carIcon;
      }else if (vehicleType.toLowerCase()==  "cab"){
        driverIcon = cabIcon;
      } else {
        driverIcon = carIcon;
      }


      LatLng rawPos = LatLng(driver["latitude"], driver["longitude"]);
      LatLng roadPos = await mapNo.snapToRoad(rawPos);

      // final bool isCar = random.nextBool();
      // final icon = isCar ? carIcon : bikeIcon;

      final existingMarker = currentMarkers.firstWhere(
        (m) => m.markerId.value == id,
        orElse: () =>
            Marker(markerId: MarkerId(id), position: roadPos, icon: driverIcon),
      );

      // 🔹 Animate marker
      unawaited(_animateMarker(markerId: id, newPosition: roadPos, icon: driverIcon));

      // 🔹 Add marker if not already in map
      if (!state.markers.any((m) => m.markerId.value == id)) {
        final updated = {...state.markers}..add(existingMarker);
        state = state.copyWith(markers: updated);
      }
    }

    // 🔹 Remove offline drivers
    final retained = state.markers
        .where((m) => !m.markerId.value.startsWith("driver_") || activeDriverIds.contains(m.markerId.value))
        .toSet();

    state = state.copyWith(markers: retained);
  }



  double calculateDistance(LatLng p1, LatLng p2) {
    const R = 6371; // km
    final dLat = (p2.latitude - p1.latitude) * pi / 180.0;
    final dLon = (p2.longitude - p1.longitude) * pi / 180.0;
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(p1.latitude * pi / 180.0) *
                cos(p2.latitude * pi / 180.0) *
                sin(dLon / 2) *
                sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _calculateBearing(LatLng from, LatLng to) {
    final double lat1 = from.latitude * (pi / 180);
    final double lon1 = from.longitude * (pi / 180);
    final double lat2 = to.latitude * (pi / 180);
    final double lon2 = to.longitude * (pi / 180);

    final double dLon = lon2 - lon1;
    final double y = sin(dLon) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = atan2(y, x);
    bearing = bearing * (180 / pi);
    return (bearing + 360) % 360; // normalize
  }


  /// Clear all driver markers
  void clearDriverVehicleMarkers() {
    final retained = state.markers
        .where((m) => !m.markerId.value.startsWith("driver_"))
        .toSet();
    state = state.copyWith(markers: retained);
  }


  Future<void> _animateMarker({
    Marker? oldMarker,
    required String markerId,
    required LatLng newPosition,
    required BitmapDescriptor icon,
  }) async
  {
    final steps = 30;
    final stepDuration = Duration(milliseconds: 30);

    oldMarker ??= state.markers.firstWhere(
      (m) => m.markerId.value == markerId,
      orElse: () => Marker(
        markerId: MarkerId(markerId),
        position: newPosition,
        rotation: 0,
        icon: icon,
      ),
    );

    final oldPos = oldMarker.position;
    final startRotation = oldMarker.rotation;
    final newBearing = _calculateBearing(oldPos, newPosition);

    double normalizeBearing(double start, double end) {
      double diff = (end - start) % 360;
      if (diff > 180) diff -= 360;
      if (diff < -180) diff += 360;
      return start + diff;
    }

    for (int i = 1; i <= steps; i++) {
      final lat =
          oldPos.latitude +
          (newPosition.latitude - oldPos.latitude) * (i / steps);
      final lng =
          oldPos.longitude +
          (newPosition.longitude - oldPos.longitude) * (i / steps);
      final rotation =
          normalizeBearing(startRotation, newBearing) * (i / steps) +
          startRotation * (1 - i / steps);
      final updatedMarker = oldMarker.copyWith(
        positionParam: LatLng(lat, lng),
        rotationParam: rotation,
        iconParam: icon,
      );
      final markers = state.markers
          .map((m) => m.markerId.value == markerId ? updatedMarker : m)
          .toSet();
      state = state.copyWith(markers: markers);

      await Future.delayed(stepDuration);
    }
  }

  /// Draw route polyline
  Future<void> drawRoute(
    LatLng origin,
    LatLng destination, {
    bool shouldUpdateDistance = true,
    bool shouldMakerAdd=true
  }) async
  {
    try {
      final mapNo = ref.read(mapRepositoryProvider);
      state = state.copyWith(isMapProcessing: true);
      final snappedDestination = await mapNo.snapToRoad(destination);
      if(shouldMakerAdd){
        final snappedOrigin = await mapNo.snapToRoad(origin);
        await addMarker(
          snappedOrigin,
          "pickup_marker",
          Assets.iconMapMarker,
          title: state.pickupAddress,
        );
        await addMarker(
          snappedDestination,
          "destination_marker",
          Assets.iconSquareMarker,
          title: state.destinationAddress,
        );

      }

      final data = await ref.read(mapNotifierProvider.notifier).drawRoutePolyline(origin, destination);
      final decoded = await _getAccuratePolyline(data);
      final polyline = Polyline(
        polylineId: const PolylineId("route"),
        color: Colors.blue,
        width: 4,
        points: decoded,
      );
      state = state.copyWith(polyline: {polyline});
      final legs = data?['routes'][0]['legs'][0];
      final distanceMeters = double.parse(legs['distance']['value'].toString());
      final durationSeconds = legs['duration']['value'];
      if (shouldUpdateDistance) {
        state = state.copyWith(
          totalDistancePolyline: distanceMeters,
          routeDurationInSec: durationSeconds,
        );
      }
      if(shouldMakerAdd){
        await moveCameraOnPolyline(decoded, origin);
      }
      state = state.copyWith(isMapProcessing: false);
    } catch (e) {
      state = state.copyWith(isMapProcessing: false);
      debugPrint("Error drawing polyline: $e");
    }
  }

  /// Decode polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  Future<List<LatLng>> _getAccuratePolyline(dynamic data) async {
    List<LatLng> polylinePoints = [];

    final routes = data["routes"] as List?;
    if (routes == null || routes.isEmpty) return [];

    final legs = routes[0]["legs"] as List?;
    if (legs == null || legs.isEmpty) return [];

    for (var leg in legs) {
      final steps = leg["steps"] as List?;
      if (steps == null) continue;

      for (var step in steps) {
        final polyline = step["polyline"]["points"];
        polylinePoints.addAll(_decodePolyline(polyline));
      }
    }

    return polylinePoints;
  }

  /// move camera polyline
  // Future<void> moveCameraOnPolyline(List<LatLng> points) async {
  //   if (points.isEmpty) return;
  //
  //   final GoogleMapController controller = await completer.future;
  //
  //   double minLat = points.first.latitude;
  //   double maxLat = points.first.latitude;
  //   double minLng = points.first.longitude;
  //   double maxLng = points.first.longitude;
  //
  //   for (var p in points) {
  //     if (p.latitude < minLat) minLat = p.latitude;
  //     if (p.latitude > maxLat) maxLat = p.latitude;
  //     if (p.longitude < minLng) minLng = p.longitude;
  //     if (p.longitude > maxLng) maxLng = p.longitude;
  //   }
  //
  //   final bounds = LatLngBounds(
  //     southwest: LatLng(minLat, minLng),
  //     northeast: LatLng(maxLat, maxLng),
  //   );
  //
  //   try {
  //     await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 30));
  //   } catch (e) {
  //     debugPrint("Error moving camera: $e");
  //     // fallback
  //     await controller.animateCamera(
  //       CameraUpdate.newLatLngZoom(points.first, 14),
  //     );
  //   }
  // }
  Future<void> moveCameraOnPolyline(List<LatLng> points, LatLng pickup) async {
    if (points.isEmpty) return;

    final GoogleMapController controller = await completer.future;

    // Optional: calculate distance to the farthest point to adjust zoom
    double maxDistance = 0;
    for (var p in points) {
      final d = calculateDistance(p, pickup); // km
      if (d > maxDistance) maxDistance = d;
    }

    // Simple zoom logic: closer points = higher zoom, farther = lower zoom
    double zoom = 16; // default close zoom
    if (maxDistance > 0.5) zoom = 15;
    if (maxDistance > 2) zoom = 14;
    if (maxDistance > 5) zoom = 13;

    try {
      await controller.animateCamera(CameraUpdate.newLatLngZoom(pickup, zoom));
    } catch (e) {
      debugPrint("Error moving camera: $e");
    }
  }

  /// confirm pickup location flow
  Future<void> enableConfirmingPickup() async {
    state = state.copyWith(
      // isConfirmingPickup: true,
      polyline: {},
      markers: {},
      draggablePickupLocation: state.pickupLocation,
      draggablePickupAddress: state.pickupAddress,
    );

    if (state.pickupLocation != null) {
      // addMarker(
      //   state.pickupLocation!,
      //   "pickup_location",
      //   Assets.iconDragablePickupMarker,
      // );
      // await _drawDottedLine();

      moveCamera(
        state.pickupLocation!.latitude,
        state.pickupLocation!.longitude,
        12,
      );
    }
  }

  /// Update pickup while dragging
  Future<void> updateDraggableLatLng(LatLng latLng) async {
    state = state.copyWith(
      draggablePickupLocation: latLng,
      isLocationLoading: true,
    );
  }

  ///after drag then map is ideal position then update
  Future<void> updateDraggableLocationAddressPolyline(LatLng center) async {
    // update pickup lat/lng
    final address = await getAddressFromLatLng(center);
    state = state.copyWith(
      draggablePickupLocation: center,
      draggablePickupAddress: address,
      isLocationLoading: false,
    );
    await _drawDottedLine();
  }

  Future<void> _drawDottedLine() async {
    if (state.pickupLocation == null || state.draggablePickupLocation == null)
      return;
    final points = [state.draggablePickupLocation!, state.pickupLocation!];
    final polyline = Polyline(
      polylineId: const PolylineId("dotted_pickup_line"),
      points: points,
      color: AppColor.primary,
      width: 2,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
    );
    state = state.copyWith(polyline: {polyline});
  }

  Future<void> cancelPickupConfirmation() async {
    final updatedMarkers = Set<Marker>.from(state.markers)
      ..removeWhere((marker) => marker.markerId.value == "pickup_location");

    state = state.copyWith(
      isConfirmingPickup: false,
      polyline: {},
      markers: updatedMarkers,
      draggablePickupLocation: null,
      draggablePickupAddress: null,
    );

    if (state.pickupLocation != null && state.destinationLocation != null) {
      await drawRoute(state.pickupLocation!, state.destinationLocation!);
    }
  }

  Future<void> confirmNewPickupLocation() async {
    if (state.draggablePickupLocation == null) return;
    state = state.copyWith(
      pickupLocation: state.draggablePickupLocation,
      pickupAddress: state.draggablePickupAddress,
      isConfirmingPickup: false,
      polyline: {},
      draggablePickupLocation: null,
      draggablePickupAddress: null,
    );

    if (state.pickupLocation != null && state.destinationLocation != null) {
      await drawRoute(
        state.pickupLocation!,
        state.destinationLocation!,
        shouldUpdateDistance: false,
      );
    }
  }

  void clearTemporaryState() {
    print("👍👍👍 clear temp data");
    clearDriverVehicleMarkers();
    stopDriverAnimation();
    _pickupToDestinationDrawn = false;
    state = state.copyWith(
      isMapProcessing: false,
      isLocationLoading: false,
      isConfirmingPickup: false,
      polyline: {},
      markers: {},
      destinationLocation: null,
      destinationAddress: null,
      driverLocation: null,
      totalDistancePolyline: null,
      routeDurationInSec: null,
      mapStyle: null,

    );

    // ref.read(mapNotifierProvider.notifier).resetSearchPlacesData();
  }
}
