  import 'dart:async';
import 'dart:math';
import 'dart:ui';

  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay/generated/assets.dart' show Assets;
import 'package:rider_pay/res/app_color.dart';
  import 'package:rider_pay/theme/theme_controller.dart';
  import 'package:rider_pay/view/map/domain/repositories/location_repo.dart';
import 'package:rider_pay/view/map/presentation/controller/map_notifier_provider.dart';
  import 'package:rider_pay/view/map/provider/map_provider.dart';

  enum LocationType { pickup, destination }


  class MapState {
    final bool isLocationLoading;
    final bool isMapProcessing;
    final bool isConfirmingPickup;


    final LatLng? pickupLocation;
    final LatLng? destinationLocation;
    final String? pickupAddress;
    final double? pickupDistanceFromCurrent;
    final LatLng? driverLocation;
    final String? destinationAddress;

    final LatLng? draggablePickupLocation;
    final String? draggablePickupAddress;


    final double? totalDistancePolyline;
    final int? routeDurationInSec;

    final String? mapStyle;
    final Set<Marker> markers;
    final Set<Polyline> polyline;



    const MapState( {
      this.isMapProcessing = false,
      this.isLocationLoading = false,
      this.isConfirmingPickup = false,

      this.pickupLocation,
      this.destinationLocation,

      this.pickupDistanceFromCurrent,
      this.totalDistancePolyline,
      this.routeDurationInSec,

      this.draggablePickupLocation,
      this.draggablePickupAddress,

      this.pickupAddress,
      this.destinationAddress,
      this.driverLocation,

      this.markers = const {},
      this.polyline = const {},
      this.mapStyle,

    });

    MapState copyWith({
      bool? isLocationLoading,
      bool? isMapProcessing,
      bool? isConfirmingPickup,

      LatLng? pickupLocation,
      LatLng? destinationLocation,
      double? pickupDistanceFromCurrent,
      double? totalDistancePolyline,
      int? routeDurationInSec,

     LatLng? draggablePickupLocation,
     String? draggablePickupAddress,

      String? pickupAddress,
      String? destinationAddress,

      LatLng? driverLocation,
      Set<Marker>? markers,
      Set<Polyline>? polyline,

      String? mapStyle,

    }) {
      return MapState(
        isLocationLoading: isLocationLoading ?? this.isLocationLoading,
          isMapProcessing: isMapProcessing ?? this.isMapProcessing,
          isConfirmingPickup: isConfirmingPickup ?? this.isConfirmingPickup,


          pickupLocation: pickupLocation ?? this.pickupLocation,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        destinationAddress: destinationAddress ?? this.destinationAddress,
        destinationLocation: destinationLocation ?? this.destinationLocation,
          pickupDistanceFromCurrent: pickupDistanceFromCurrent ,
          routeDurationInSec: routeDurationInSec ?? this.routeDurationInSec,
          totalDistancePolyline: totalDistancePolyline??this.totalDistancePolyline ,
         draggablePickupLocation: draggablePickupLocation ?? this.draggablePickupLocation,
         draggablePickupAddress: draggablePickupAddress ?? this.draggablePickupAddress,
          driverLocation: driverLocation ?? this.driverLocation,
        markers: markers ?? this.markers,
        mapStyle: mapStyle ?? this.mapStyle,
        polyline: polyline?? this.polyline

      );
    }
  }


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
          (mode == ThemeMode.dark) || (mode == ThemeMode.system &&
              platformBrightness == Brightness.dark);

      final stylePath = effectiveDark
          ? "assets/dark_mode_map.json"
          : "assets/light_mode_map.json";

      final style = await rootBundle.loadString(stylePath);

      if (completer.isCompleted) {
        try {
          final controller = await completer.future;
          await controller.setMapStyle(style);
          print("✅ Map style applied: ${effectiveDark ? 'Dark' : 'Light'}");
        } catch (e) {
          print("❌ setMapStyle failed: $e");
        }
      }
    }
    static const String currentLocationText = "Your current location";

    Future<String> fetchCurrentLocation({LocationType? type = LocationType.pickup}) async {
      state = state.copyWith(isLocationLoading: true);

      try {
        // 🔹 Check location service & permission
        final hasPermission = await ref.read(locationServiceProvider.notifier).ensurePermission();
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
    Future<bool> selectLocationAndUpdateMap({
      required LocationType type,
      required LatLng latLng,
      String? address,
    }) async
    {
      state = state.copyWith(isMapProcessing: true);
      await setLocation(type: type, latLng: latLng, address: address);
      if (state.pickupLocation != null && state.destinationLocation != null) {
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
        state = state.copyWith(pickupLocation: latLng, pickupAddress: resolvedAddress);
      } else {
        state = state.copyWith(destinationLocation: latLng, destinationAddress: resolvedAddress);
      }
    }
    Future<String> getAddressFromLatLng(LatLng latLng) async {
      try {
        final placeMarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
        final place = placeMarks.first;
        return "${place.name}, ${place.locality}, ${place.postalCode}";
      } catch (e) {
        debugPrint("Reverse geocode failed: $e");
        return "${latLng.latitude},${latLng.longitude}";
      }
    }

    Future<void> moveCamera(double lat, double lng, double zoom) async {
      final controller = await completer.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: zoom),
      ));
    }

    Future<void> setPickupLatLng(LatLng value) async {
      state = state.copyWith(pickupLocation: value);
    }

    Future<void> setDestLatLng(LatLng value) async {
      state = state.copyWith(destinationLocation: value);
    }
    /// Reverse geocoding

    Future<BitmapDescriptor> _resizeImage(String assetPath, int width) async {
      final byteData = await rootBundle.load(assetPath);
      final codec = await instantiateImageCodec(
        byteData.buffer.asUint8List(),
        targetWidth: width,
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(format: ImageByteFormat.png);
      return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
    }


    /// Add marker
    Future<void> addMarker(LatLng position, String markerId, String assetPath) async {
      try {
        final icon = await _resizeImage(assetPath, 40);
        final marker = Marker(
          markerId: MarkerId(markerId),
          position: position,
          icon: icon,
        );

        final updated = {...state.markers}..removeWhere((m) => m.markerId.value == markerId);
        updated.add(marker);

        state = state.copyWith(markers: updated);
      } catch (e) {
        debugPrint("Marker error: $e");
      }
    }

    /// Draw route polyline
    Future<void> drawRoute(LatLng origin, LatLng destination) async {
      try {
        await  addMarker(state.pickupLocation!, "pickup_marker", Assets.iconMapMarker,);
       await  addMarker(state.destinationLocation!, "destination_marker", Assets.iconSquareMarker);
       final data = await ref.read(mapNotifierProvider.notifier).drawRoutePolyline(origin, destination);
       final decoded = await _getAccuratePolyline(data);
        final polyline = Polyline(
          polylineId: const PolylineId("route"),
          color: Colors.black,
          width: 2,
          points: decoded,
        );
        state = state.copyWith(polyline: {polyline});
        final legs = data?['routes'][0]['legs'][0];
        final distanceMeters = legs['distance']['value'];
        final durationSeconds = legs['duration']['value'];
        print(" distance meter $distanceMeters $durationSeconds");
        state = state.copyWith(totalDistancePolyline: distanceMeters.toDouble(), routeDurationInSec: durationSeconds,);
        print("${state.totalDistancePolyline}");
       await moveCameraOnPolyline(decoded);
      } catch (e) {
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
    Future<void> moveCameraOnPolyline(List<LatLng> points) async {
      if (points.isEmpty) return;

      final GoogleMapController controller = await completer.future;

      double minLat = points.first.latitude;
      double maxLat = points.first.latitude;
      double minLng = points.first.longitude;
      double maxLng = points.first.longitude;

      for (var p in points) {
        if (p.latitude < minLat) minLat = p.latitude;
        if (p.latitude > maxLat) maxLat = p.latitude;
        if (p.longitude < minLng) minLng = p.longitude;
        if (p.longitude > maxLng) maxLng = p.longitude;
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      try {
        await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
      } catch (e) {
        debugPrint("Error moving camera: $e");
        // fallback
        await controller.animateCamera(CameraUpdate.newLatLngZoom(points.first, 14));
      }
    }

   /// confirm pickup location flow
    Future<void> enableConfirmingPickup() async {
      state = state.copyWith(
        isConfirmingPickup: true,
        polyline: {},
        markers: {},
        draggablePickupLocation: state.pickupLocation,
        draggablePickupAddress: state.pickupAddress);

      if (state.pickupLocation != null) {
        addMarker(state.pickupLocation!, "pickup_location", Assets.iconDragablePickupMarker);
        await _drawDottedLine();

        moveCamera(
          state.pickupLocation!.latitude,
          state.pickupLocation!.longitude,
          12,
        );
      }

    }




    /// Update pickup while dragging
    Future<void> updateDraggableLatLng(LatLng latLng)async{
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

    }


    Future<void> _drawDottedLine() async {
      if (state.pickupLocation == null || state.draggablePickupLocation == null) return;
      final points = [state.pickupLocation!, state.draggablePickupLocation!];
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
      state = state.copyWith(
        isConfirmingPickup: false,
        polyline: {},
        draggablePickupLocation: null,
        draggablePickupAddress: null,
      );
      if (state.pickupLocation != null && state.destinationLocation != null) {
        await drawRoute(state.pickupLocation!, state.destinationLocation!);
      }
    }




    Future<void> confirmNewPickupLocation() async {
      if (state.draggablePickupLocation == null) return;

      // NAYA CHANGE: Ab temporary location ko permanent `pickupLocation` bana do
      state = state.copyWith(
        pickupLocation: state.draggablePickupLocation,
        pickupAddress: state.draggablePickupAddress,
        isConfirmingPickup: false,
        polyline: {}, // Dotted line hata do
        // Temporary variables ko clear kar do
        draggablePickupLocation: null,
        draggablePickupAddress: null,
      );

      // Ab NAYE permanent pickup location se final route banao
      if (state.pickupLocation != null && state.destinationLocation != null) {
        await drawRoute(state.pickupLocation!, state.destinationLocation!);
      }
    }











    /// Confirm pickup (final fix)
    /// Confirm pickup (final fix)
    // Future<void> confirmPickup(LatLng latLng, String address) async {
    //   state = state.copyWith(
    //     pickupLocation: latLng,
    //     pickupAddress: address,
    //     isConfirmingPickup: false,
    //     polyline: {}, // clear dotted
    //     markers: {},  // clear center
    //   );
    //
    //   if (state.pickupLocation != null && state.destinationLocation != null) {
    //     await drawRoute(state.pickupLocation!, state.destinationLocation!);
    //   }
    // }
    // /// Re-draw old route if back from confirm pickup
    // Future<void> restoreOldRoute() async {
    //   state = state.copyWith(polyline: {});
    //   if (state.pickupLocation != null && state.destinationLocation != null) {
    //     await drawRoute(state.pickupLocation!, state.destinationLocation!);
    //   }
    // }
    //
    // Future<void> drawDottedLineFromCurrentToPickup() async {
    //   final current = await _repo.getCurrentLocation();
    //   if (current == null || state.pickupLocation == null) return;
    //
    //   final List<LatLng> points = [
    //     LatLng(current.latitude, current.longitude),
    //     state.pickupLocation!,
    //   ];
    //
    //   final polyline = Polyline(
    //     polylineId: const PolylineId("dottedLine"),
    //     points: points,
    //     color: Colors.blue,
    //     width: 3,
    //     patterns: [PatternItem.dash(20), PatternItem.gap(10)], // dotted effect
    //   );
    //
    //   state = state.copyWith(polyline: {polyline});
    // }

    double calculateDistance(LatLng start, LatLng end) {
      const double R = 6371000;
      final dLat = (end.latitude - start.latitude) * (3.14159 / 180);
      final dLng = (end.longitude - start.longitude) * (3.14159 / 180);
      final a = (sin(dLat/2) * sin(dLat/2)) +
              cos(start.latitude * (3.14159 / 180)) *
                  cos(end.latitude * (3.14159 / 180)) *
                  (sin(dLng/2) * sin(dLng/2));
      final c = 2 * atan2(sqrt(a), sqrt(1-a));
      return R * c;
    }


    // Future<void> updatePickupFromCamera(LatLng center) async {
    //   state = state.copyWith(isLocationLoading: true);
    //
    //   final address = await getAddressFromLatLng(center);
    //   final current = await _repo.getCurrentLocation();
    //   double? distance;
    //   if (current != null) {
    //     distance = calculateDistance(
    //       LatLng(current.latitude, current.longitude),
    //       center,
    //     );
    //   }
    //   state = state.copyWith(
    //     pickupLocation: center,
    //     pickupAddress: address,
    //     isLocationLoading: false,
    //     pickupDistanceFromCurrent: distance,
    //   );
    // }


   /// set location  for searching and check then  draw polyline

    // void resetNavigationFlag({bool? navi}) {
    //   state = state.copyWith(shouldNavigate: navi ?? false);
    // }

    void clearPickup() {
      state = state.copyWith(pickupLocation: null, pickupAddress: null);
    }

    void clearDestination() {
      state = state.copyWith(destinationLocation: null, destinationAddress: null);
    }

    void clearTemporaryState() {
      print("👍👍👍 clear temp data");
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
        mapStyle: null
      );

      // ref.read(mapNotifierProvider.notifier).resetSearchPlacesData();
    }
  }