
import 'package:google_maps_flutter/google_maps_flutter.dart';

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