  
  
  import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:geolocator/geolocator.dart';
  import 'package:rider_pay_user/view/map/domain/repositories/location_repo.dart';

  
  
  class LocationState {
    final bool isLoading;
    final bool isGranted;
    final bool isBlocked;
  
    const LocationState({
      this.isLoading = false,
      this.isGranted = false,
      this.isBlocked = false,
    });
  
    LocationState copyWith({
      bool? isLoading,
      bool? isGranted,
      bool? isBlocked,
    }) {
      return LocationState(
        isLoading: isLoading ?? this.isLoading,
        isGranted: isGranted ?? this.isGranted,
        isBlocked: isBlocked ?? this.isBlocked,
      );
    }
  }

  class LocationServiceNotifier extends StateNotifier<LocationState> {
    final LocationRepository _repo;
    LocationServiceNotifier(this._repo) : super(const LocationState());

    Future<bool> ensurePermission() async {
      debugPrint("[LOCATION] Checking permission...");
      state = state.copyWith(isLoading: true);

      final serviceEnabled = await _repo.isLocationServiceEnabled();
      debugPrint("[LOCATION] Service enabled: $serviceEnabled");
      if (!serviceEnabled) {
        state = state.copyWith(isLoading: false, isGranted: false);
        debugPrint("[LOCATION] ❌ Service disabled");
        return false;
      }

      LocationPermission permission = await _repo.checkPermission();
      debugPrint("[LOCATION] Current permission: $permission");

      if (permission == LocationPermission.denied) {
        permission = await _repo.requestPermission();
        debugPrint("[LOCATION] After request: $permission");
      }

      if (permission == LocationPermission.denied) {
        state = state.copyWith(isLoading: false, isGranted: false);
        debugPrint("[LOCATION] ❌ Permission denied");
        return false;
      } else if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(isLoading: false, isGranted: false, isBlocked: true);
        debugPrint("[LOCATION] ❌ Permission denied forever");
        return false;
      } else {
        state = state.copyWith(isLoading: false, isGranted: true);
        debugPrint("[LOCATION] ✅ Permission granted");
        return true;
      }
    }
  }
  
  // class LocationServiceNotifier extends StateNotifier<LocationState>{
  //   final LocationRepository _repo;
  //   LocationServiceNotifier(this._repo) : super(const LocationState());
  //
  //
  //   Future<bool> ensureLocation(BuildContext context, WidgetRef ref) async {
  //     await _checkPermission(context, ref);
  //     return state.isGranted;
  //   }
  //   Future<void> _checkPermission(BuildContext context, WidgetRef ref) async {
  //     state = state.copyWith(isLoading: true);
  //
  //     final serviceEnabled = await _repo.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       state = state.copyWith(isLoading: false, isGranted: false);
  //       _showPopup(context, ref, isBlocked: false, isServiceOff: true);
  //       return;
  //     }
  //
  //     LocationPermission permission = await _repo.checkPermission();
  //
  //     if (permission == LocationPermission.denied) {
  //       permission = await _repo.requestPermission();
  //     }
  //
  //     if (permission == LocationPermission.denied) {
  //       state = state.copyWith(isLoading: false, isGranted: false);
  //       _showPopup(context, ref, isBlocked: false);
  //     } else if (permission == LocationPermission.deniedForever) {
  //       state = state.copyWith(isLoading: false, isGranted: false, isBlocked: true);
  //       _showPopup(context, ref, isBlocked: true);
  //     } else {
  //       state = state.copyWith(isLoading: false, isGranted: true);
  //     }
  //   }
  //
  //   Future<void> _showPopup(BuildContext context, WidgetRef ref,
  //       {bool isBlocked = false, bool isServiceOff = false}) async {
  //
  //      CustomSlideDialog.show(
  //       context: context,
  //       child: LocationOnPopup(
  //         isBlocked: isBlocked,
  //         isServiceOff: isServiceOff,
  //         onAction: () async {
  //           Navigator.pop(context);
  //           if (isServiceOff) {
  //             await _repo.openLocationSettings();
  //           } else if (isBlocked) {
  //             await _repo.openAppSettings();
  //           }
  //           await _checkPermission(context, ref);
  //         },
  //       ),
  //     );
  //   }
  //
  // }