import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/helper/network/network_api_service_http.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/map/data/repositories/check_zone_impl.dart';
import 'package:rider_pay_user/view/map/domain/repositories/check_zone_repo.dart';

class CheckZoneState {
  final bool isLoading;

  CheckZoneState({this.isLoading = false});

  CheckZoneState copyWith({bool? isLoading}) {
    return CheckZoneState(isLoading: isLoading ?? this.isLoading);
  }
}

class CheckZoneNotifier extends StateNotifier<CheckZoneState> {
  final CheckZoneRepo repo;

  CheckZoneNotifier(this.repo) : super(CheckZoneState());

  Future<bool> checkZone({
    required String pickLat,
    required String pickLng,
    required String destLat,
    required String destLng,
  }) async {
    state = state.copyWith(isLoading: true);

    Map<String, dynamic> payload = {
      "pickup_lat": pickLat,
      "pickup_lng": pickLng,
      "drop_lat": destLat,
      "drop_lng": destLng,
    };
    try {
      final v = await repo.checkZoneApi(payload);
      if (v["code"] == 200) {
        return true;
      } else {
        toastMsg(v["msg"]);
        return false;
      }
    } catch (e) {
      debugPrint("Check zone error: $e");
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final checkZoneProvider =
    StateNotifierProvider<CheckZoneNotifier, CheckZoneState>(
      (ref) => CheckZoneNotifier(CheckZoneImpl(NetworkApiServices(ref))),
    );
