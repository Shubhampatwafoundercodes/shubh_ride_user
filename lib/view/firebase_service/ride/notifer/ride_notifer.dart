import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/firebase_service/ride/data/model/ride_booking_model.dart';
import 'package:rider_pay_user/view/firebase_service/ride/data/repo_impl/ride_repo_impl.dart';
import 'package:rider_pay_user/view/firebase_service/ride/domain/ride_repo.dart';
import 'package:rider_pay_user/view/firebase_service/ride/firebase_ride_key.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';

/// ---------------- RIDE STATE ----------------
class RideState {
  final bool isLoading;
  final bool isAcceptingDriver;
  final RideBookingModel? currentRide;

  RideState({
    required this.isLoading,
    required this.isAcceptingDriver,
    this.currentRide,
  });

  factory RideState.initial() =>
      RideState(isLoading: false, isAcceptingDriver: false, currentRide: null);

  RideState copyWith({
    bool? isLoading,
    bool? isAcceptingDriver,
    RideBookingModel? currentRide,
  }) {
    return RideState(
      isLoading: isLoading ?? this.isLoading,
      isAcceptingDriver: isAcceptingDriver ?? this.isAcceptingDriver,
      currentRide: currentRide ?? this.currentRide,
    );
  }
}

/// ---------------- RIDE NOTIFIER ----------------
class RideNotifier extends StateNotifier<RideState> {
  final RideRepo _repo;
  final Ref ref;
  StreamSubscription<RideBookingModel?>? _rideListener;
  // StreamSubscription<Map<String, dynamic>?>? _driverLocationListener;
  // StreamSubscription? _driverStream;
  StreamSubscription? _activeDriverStream;


  bool _pickupToDestinationDrawn = false;
  RideNotifier(this._repo, this.ref) : super(RideState.initial());

  /// lis nearBy driver vehicle location

    void listenToNearbyDriverVehicleLocation(LatLng pickup) async {
      stopListeningDrivers();
      final mapConNo = ref.read(mapControllerProvider.notifier);
      _activeDriverStream = _repo.listenToOnlineDrivers().listen((drivers) async {

        final filterDriversMarker = drivers.where((d) {
          if (d["latitude"] == null || d["longitude"] == null) {
            debugPrint("⚠️ Skipping driver: missing lat/lng → ${d["id"]}");
            return false;
          }
          final dist = mapConNo.calculateDistance(
            pickup,
            LatLng(d["latitude"], d["longitude"]),
          );


          final withinRange = dist <= 5;
          if (withinRange) {
            debugPrint("✅ Driver ${d["id"]} within 5km → $dist km away");
          } else {
            debugPrint("❌ Driver ${d["id"]} too far → $dist km away");
          }
          return withinRange;
        }).toList();

        if (filterDriversMarker.isEmpty) {
          mapConNo.clearDriverVehicleMarkers();
        } else {
          await mapConNo.updateAnimatedDriverMarkers(filterDriversMarker);
        }
      });
    }


  void startDriverLocationListener(String driverId, String vehicleType, LatLng pickupLatLng) {
    print("🎧 Starting driver location listener for $driverId");
    stopListeningDrivers();
    final mapConN=ref.read(mapControllerProvider.notifier);
    final driverStream = _repo.listenToDriverLocationById(driverId);
    _activeDriverStream?.cancel();
    _activeDriverStream = driverStream.listen((driverData) async {
      if (driverData == null) return;
      final lat = driverData["latitude"];
      final lng = driverData["longitude"];
      if (lat == null || lng == null) return;
      final newPosition = LatLng(lat, lng);
      print("🚗 Driver new position: $newPosition");
      await mapConN.listenToDriverMarker(
        driverLatLng: newPosition,
        pickupLatLng: pickupLatLng,
        vehicleType: vehicleType,
      );
    });
  }





  void stopListeningDrivers() {
    final mapConNo = ref.read(mapControllerProvider.notifier);
    _activeDriverStream?.cancel();
    _activeDriverStream = null;
    mapConNo.clearDriverVehicleMarkers();
  }

  Future<void> bookRideAndListen(RideBookingModel ride) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repo.bookRide(ride);
      listenToSingleRide(ride.rideId);
      state = state.copyWith(isLoading: false, currentRide: ride);
      print("✅ Ride booked and listener started for ${ride.rideId}");
    } catch (e) {
      print("❌ bookRideAndListen error: $e");
      state = state.copyWith(isLoading: false);
    }
  }

  /// ✅ Real-time listener for a single ride

  void listenToSingleRide(String? rideId) {
    if (rideId == null) return;
    _pickupToDestinationDrawn = false;
    state = state.copyWith(isLoading: true);
    // final mapCon = ref.read(mapControllerProvider.notifier);
    _rideListener?.cancel(); // cancel old listener
    print("🎧 Listening for ride: $rideId");
    _rideListener = _repo
        .listenToRideById(rideId)
        .listen((ride) {
            print("🔄 Stream update received → ${ride?.status ?? 'Deleted'}");
            state = state.copyWith(currentRide: ride, isLoading: false);
            // mapCon.listenToDriverMarker(ride);
            if (ride?.status.toLowerCase() == "otp_verified" || (ride?.statusText ?? "").toLowerCase() == "otp verified") {
              drawPickupToDestinationOnce();
            }
          },
          onError: (e) {
            state = state.copyWith(isLoading: false);
            print("❌ Stream error: $e");
          },
        );
  }





  /// ✅ Cancel ride + stop stream + clear state
  Future<void> cancelRideAndStopListening(String rideId) async {
    try {
      await _repo.updateRideFields(rideId, {
        FirebaseRideKeys.status: 'cancelled_by_user',
      });
      print("🛑 Ride $rideId cancelled by user in Firebase");
      stopListening();
      state = RideState.initial();
      print("🧹 Stream stopped & state cleared");
    } catch (e) {
      print("❌ cancelRideAndStopListening error: $e");
    }
  }

  Future<void> updateRide(String rideId, Map<String, dynamic> data) async {
    try {
      await _repo.updateRideFields(rideId, data);
      print("✅ Ride $rideId updated with $data");
    } catch (e) {
      print("❌ updateRide error: $e");
    }
  }

  Future<void> updateRideField(String rideId, String key, dynamic value) async {
    await updateRide(rideId, {key: value});
  }

  // Future<void> acceptDriverIfAvailable(
  //   String rideId,
  //   String driverId,
  //   Map<String, dynamic> driver,
  // ) async
  // {
  //   try {
  //     state = state.copyWith(isAcceptingDriver: true);
  //     final driverDoc = await _repo.getDriverDetails(driverId);
  //     if (driverDoc == null) {
  //       print("⚠️ Driver $driverId not found");
  //       state = state.copyWith(isAcceptingDriver: false);
  //       return;
  //     }
  //
  //     print("🚕 Checking driver availability for $driverId...");
  //
  //     final availability = (driverDoc['availability'] ?? '')
  //         .toString()
  //         .toLowerCase();
  //
  //     if (availability != 'online') {
  //       toastMsg(" Driver $driverId is $availability, rejecting...");
  //       await _repo.rejectDriverIfBusy(rideId, driverId);
  //       state = state.copyWith(isAcceptingDriver: false);
  //       return;
  //     }
  //
  //     if (availability.toLowerCase() == 'busy') {
  //       toastMsg(" Driver is busy, rejecting");
  //       await _repo.rejectDriverIfBusy(rideId, driverId);
  //       state = state.copyWith(isAcceptingDriver: false);
  //
  //       return;
  //     }
  //     final mapController = _ref.read(mapControllerProvider.notifier);
  //
  //     // try {
  //     //   await updateDriverStatus(driverId, rideId, "busy");
  //     // } catch (e) {
  //     //   toastMsg("Driver $driverId is busy now.");
  //     //   await _repo.rejectDriverIfBusy(rideId, driverId);
  //     //   state = state.copyWith(isAcceptingDriver: false);
  //     //   return;
  //     // }
  //     await _repo.updateRideFields(rideId, {
  //       FirebaseRideKeys.driverId: driverId,
  //       FirebaseRideKeys.requestedDriverList: [driverDoc],
  //       FirebaseRideKeys.acceptedByDriver: true,
  //       FirebaseRideKeys.status: 'Ongoing',
  //       FirebaseRideKeys.statusText: 'Start',
  //     });
  //     print("Driver $driverId accepted for ride $rideId");
  //     await Future.delayed(const Duration(milliseconds: 600));
  //     final driverLocation = driverDoc['location'];
  //     if (driverLocation == null) {
  //       print("⚠️ Driver location missing");
  //       return;
  //     }
  //     final driverLat = double.tryParse(driverLocation['latitude'].toString());
  //     final driverLng = double.tryParse(driverLocation['longitude'].toString());
  //
  //     final rideState = _ref.read(rideNotifierProvider).currentRide;
  //     final pickup = rideState?.pickupLocation;
  //     final pickupLat = double.tryParse(pickup?['lat'].toString() ?? '');
  //     final pickupLng = double.tryParse(pickup?['lng'].toString() ?? '');
  //     final vehicleType = (driverDoc['vehicleType'] ?? 'bike').toString().toLowerCase();
  //     if (driverLat != null && driverLng != null && pickupLat != null && pickupLng != null) {
  //       final origin = LatLng(driverLat, driverLng);
  //       final destination = LatLng(pickupLat, pickupLng);
  //       await mapController.listenToDriverMarker(
  //         driverLatLng: origin,
  //         pickupLatLng: destination,
  //         vehicleType: vehicleType,
  //       );        print("🗺️ Polyline drawn: Driver → Pickup point.");
  //     } else {
  //       print("⚠️ Coordinates missing, polyline not drawn.");
  //     }
  //   } catch (e) {
  //     state = state.copyWith(isAcceptingDriver: false);
  //     print("acceptDriverIfAvailable error: $e");
  //   } finally {
  //     state = state.copyWith(isAcceptingDriver: false);
  //   }
  // }




  Future<void> acceptDriverIfAvailable(
      String rideId,
      String driverId,
      Map<String, dynamic> driver,
      ) async
  {
    try {
      print("🚀 acceptDriverIfAvailable STARTED for driver: $driverId");
      state = state.copyWith(isAcceptingDriver: true);

      final driverDoc = await _repo.getDriverDetails(driverId);
      print("📄 driverDoc: $driverDoc");

      if (driverDoc == null) {
        print("⚠️ Driver $driverId not found");
        state = state.copyWith(isAcceptingDriver: false);
        return;
      }

      final availability = (driverDoc['availability'] ?? '').toString().toLowerCase();
      print("👀 Driver availability: $availability");

      if (availability != 'online') {
        toastMsg("Driver $driverId is $availability, rejecting...");
        await _repo.rejectDriverIfBusy(rideId, driverId);
        state = state.copyWith(isAcceptingDriver: false);
        return;
      }

      final mapController = ref.read(mapControllerProvider.notifier);

      await _repo.updateRideFields(rideId, {
        FirebaseRideKeys.driverId: driverId,
        FirebaseRideKeys.requestedDriverList: [driverDoc],
        FirebaseRideKeys.acceptedByDriver: true,
        FirebaseRideKeys.status: 'Ongoing',
        FirebaseRideKeys.statusText: 'Start',
      });
      print("✅ Ride fields updated successfully");

      // await Future.delayed(const Duration(milliseconds: 600));

      final driverLocation = driverDoc['location'];
      if (driverLocation == null) {
        print("⚠️ Driver location missing in driverDoc");
        return;
      }

      final driverLat = double.tryParse(driverLocation['latitude'].toString());
      final driverLng = double.tryParse(driverLocation['longitude'].toString());
      print("📍 Driver location → Lat: $driverLat, Lng: $driverLng");

      // final rideState = ref.read(rideNotifierProvider).currentRide;
      final pickup = state.currentRide?.pickupLocation;
      print("📦 Pickup location → $pickup");

      final pickupLat = double.tryParse(pickup?['lat'].toString() ?? '');
      final pickupLng = double.tryParse(pickup?['lng'].toString() ?? '');

      final vehicleType = (driverDoc['vehicleType'] ?? 'bike').toString().toLowerCase();
      print("🚘 Vehicle type: $vehicleType");

      if (driverLat != null && driverLng != null && pickupLat != null && pickupLng != null) {
        final origin = LatLng(driverLat, driverLng);
        final destination = LatLng(pickupLat, pickupLng);

        print("📡 Calling listenToDriverMarker → Origin: $origin, Dest: $destination");
        await mapController.listenToDriverMarker(
          driverLatLng: origin,
          pickupLatLng: destination,
          vehicleType: vehicleType,
        );
        print("✅ listenToDriverMarker completed successfully");

        print("🎯 Starting driver live location stream...");
        startDriverLocationListener(driverId, vehicleType, destination);
        print("✅ listenToDriverMarker completed successfully");
      } else {
        print("⚠️ Invalid coordinates — Polyline not drawn");
      }
    } catch (e, st) {
      state = state.copyWith(isAcceptingDriver: false);
      print("❌ acceptDriverIfAvailable ERROR: $e\n$st");
    } finally {
      state = state.copyWith(isAcceptingDriver: false);
    }
  }

  /// 🔄 Update driver status (e.g. Online, Busy, Offline)
  Future<void> updateDriverStatus(
    String driverId,
    String rideId,
    String status,
  ) async
  {
    try {
      print(
        "🚗 Updating driver $driverId status to '$status' for ride $rideId",
      );

      await _repo.updateDriverStatus(driverId, rideId, status);

      print("✅ Driver $driverId status updated to '$status'");
    } catch (e) {
      print("❌ Failed to update driver status: $e");
    }
  }


  /// ✅ Draw pickup → destination route once (after OTP verified)
  Future<void> drawPickupToDestinationOnce() async {
    if (_pickupToDestinationDrawn) return;
    final ride = state.currentRide;
    if (ride == null) return;
    final pickup = ride.pickupLocation;
    final destination = ride.dropLocation;
    final pickupLat = pickup['lat'];
    final pickupLng = pickup['lng'];
    final destLat = destination['lat'];
    final destLng = destination['lng'];

    if (pickupLat != null &&
        pickupLng != null &&
        destLat != null &&
        destLng != null) {
      final mapController = ref.read(mapControllerProvider.notifier);
      mapController.clearPickup();
      await mapController.drawRoute(
        LatLng(pickupLat, pickupLng),
        LatLng(destLat, destLng),
      );
      _pickupToDestinationDrawn = true;
      print("✅ Polyline drawn: Pickup → Destination");
    } else {
      print("⚠️ Missing pickup or destination coordinates");
    }
  }

  Future<void> rejectDriver(String rideId, String driverId) async {
    try {
      await _repo.rejectDriverIfBusy(rideId, driverId);
      print("🚫 Driver $driverId rejected from notifier");
    } catch (e) {
      print("❌ rejectDriver error: $e");
    }
  }

  ///  Stop stream manually (used after completion or logout)
  void stopListening() {
    _rideListener?.cancel();
    _rideListener = null;
    _activeDriverStream?.cancel();
    _activeDriverStream = null;
    state = state.copyWith(currentRide: null);
    print("🔇 Ride + Driver listeners stopped");
  }
  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}

/// ---------------- PROVIDERS ----------------
final rideRepoProvider = Provider<RideRepo>((ref) => RideRepoImpl());

final rideNotifierProvider = StateNotifierProvider<RideNotifier, RideState>((ref,) {
  final repo = ref.read(rideRepoProvider);
  return RideNotifier(repo, ref);
});


