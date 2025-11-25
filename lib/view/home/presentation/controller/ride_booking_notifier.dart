// ignore: unused_import
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateNotifier, Ref;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_user/view/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_user/view/home/data/model/ride_history_booking_model.dart';
import 'package:rider_pay_user/view/home/domain/repo/ride_booking_repo.dart';
import 'package:rider_pay_user/view/map/presentation/controller/ride_flow_controller.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';
import 'package:rider_pay_user/view/share_pref/user_provider.dart';

class RideBookingState {
  final bool isLoading;
  final bool isRideHistoryLoading;
  final RideBookingHistoryModel? bookingHistoryModelData;
  final String? rideId;

  RideBookingState( {
    this.isLoading = false,
    this.isRideHistoryLoading = false,
    this.bookingHistoryModelData,
    this.rideId,
  });

  RideBookingState copyWith({
    bool? isLoading,
    bool? isRideHistoryLoading,
    RideBookingHistoryModel? bookingHistoryModelData,
    String? rideId,
  }) {
    return RideBookingState(
      isLoading: isLoading ?? this.isLoading,
      isRideHistoryLoading: isRideHistoryLoading ?? this.isRideHistoryLoading,
      bookingHistoryModelData: bookingHistoryModelData ,
      rideId: rideId ?? this.rideId,
    );
  }
}



class RideBookingNotifier extends StateNotifier<RideBookingState> {
  final RideBookingRepo repo;
  final Ref ref;

  RideBookingNotifier(this.repo, this.ref) : super(RideBookingState());

  Future<String?> bookRide(Map<String, dynamic> payload) async {
    state = state.copyWith(isLoading: true,);
    try {
      final res = await repo.bookRide(payload);
      if(res["code"]==200){
        final rideID= res["data"]["ride_id"];
        state = state.copyWith(isLoading: false, rideId: rideID);
        return rideID.toString();
      }else{
        state = state.copyWith(isLoading: false, rideId: null);
        return null;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, );
      return null;
    }
  }


  Future<void> cancelRideApi(Map<String, dynamic> data) async {
   print("data cancelapi $data");
    state = state.copyWith(isLoading: true, );
    try {
      final res = await repo.cancelBooking(data);
      if(res["code"]==200){
        state = state.copyWith(isLoading: false,rideId: null);
      }else{
        state = state.copyWith(isLoading: false, rideId: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, );
    }
  }



  Future<void> rideHistoryApi(String userId) async {
    state = state.copyWith(isRideHistoryLoading: true,bookingHistoryModelData: null);
    try {
      final res = await repo.rideBookingHistoryApi(userId);

      if (res.code == 200) {
        state = state.copyWith(
          isRideHistoryLoading: false,
          bookingHistoryModelData: res,
        );

      } else {
        state = state.copyWith(
          isRideHistoryLoading: false,
          bookingHistoryModelData: null,
        );
      }
    } catch (e) {

      state = state.copyWith(isRideHistoryLoading: false);
    }
  }

  /// 🧩 This returns the pending ride (if any)
  RideHistorySingleDataModel? get pendingRide {
    final pending = state.bookingHistoryModelData?.data?.pending;
    // print("🔍 pendingRide getter → ${pending == null ? 'NULL' : pending.rideId}");
    return pending;
  }

  Future<bool> checkPendingRideAndSetup() async {
    try {
      final userId=ref.read(userProvider.notifier).userId;
      await rideHistoryApi(userId.toString());
      final pending = pendingRide;
        debugPrint("🟢 Checking pending ride in local history...");
      if (pending != null && (pending.rideId?.isNotEmpty ?? false) && (pending.status?.toLowerCase() == "pending")) {
        final rideId = pending.rideId!;
        debugPrint("🟢 Pending ride found → $rideId");
        final rideRepo = ref.read(rideRepoProvider);
        final rideData = await rideRepo.getRideOnce(rideId);
        if (rideData == null) {
          debugPrint("❌ Ride not found in Firebase — stay on Home");
          return false;
        }
        final status = (rideData['status'] ?? '').toString().toLowerCase();
        debugPrint("📡 Firebase Ride Status: $status");
        if (status == 'cancelled' || status == 'completed') {
          debugPrint("🚫 Ride already $status — do not navigate");
          return false;
        }
        final rideN = ref.read(rideNotifierProvider.notifier);
        rideN.listenToSingleRide(rideId);
        ref.read(rideFlowProvider.notifier).goTo(RideStep.waitingForDriver);
        return true;
      }
      debugPrint("✅ No pending ride found — user free");
      return false;
    } catch (e, st) {
      debugPrint("❌ checkPendingRideAndSetup error: $e\n$st");
      return false;
    }
  }

  Future<bool> setupPendingRideAndDrawRoute() async {
    final mapN = ref.read(mapControllerProvider.notifier);
    try {
      final userId = ref.watch(userProvider.notifier).userId;
      await rideHistoryApi(userId.toString());

      final pending = pendingRide;
      debugPrint("🟢 Checking pending ride...");

      if (pending != null &&
          (pending.rideId?.isNotEmpty ?? false) &&
          (pending.status?.toLowerCase() == "pending")) {

        final rideId = pending.rideId!;
        debugPrint("🟢 Pending ride found → $rideId");

        final rideRepo = ref.read(rideRepoProvider);
        final rideData = await rideRepo.getRideOnce(rideId);

        if (rideData == null) {
          debugPrint("❌ Ride not found in Firebase — stay on Home");
          return false;
        }

        final status = (rideData['status'] ?? '').toString().toLowerCase();
        debugPrint("📡 Firebase Ride Status: $status");

        if (status == 'cancelled' || status == 'completed') {
          debugPrint("🚫 Ride already $status — do not navigate");
          return false;
        }

        // Listen to ride
        final rideN = ref.read(rideNotifierProvider.notifier);
        rideN.listenToSingleRide(rideId);
        ref.read(rideFlowProvider.notifier).goTo(RideStep.waitingForDriver);

        // Set pickup & drop
        if (pending.pickupLat != null && pending.dropLat != null) {
          final pickup = LatLng(
            double.parse(pending.pickupLat!),
            double.parse(pending.pickupLng!),
          );
          final destination = LatLng(
            double.parse(pending.dropLat!),
            double.parse(pending.dropLng!),
          );

          mapN.setPickupLatLng(pickup);
          mapN.setDestLatLng(destination);

          // Draw route
          // await mapN.drawRoute(pickup, destination);

          debugPrint("🗺️ Polyline drawn successfully for pending ride!");
        }

        return true;
      }

      debugPrint("✅ No pending ride found — user free");
      return false;

    } catch (e, st) {
      debugPrint("❌ setupPendingRideAndDrawRoute error: $e\n$st");
      return false;
    }
  }

}
