import 'package:flutter_riverpod/flutter_riverpod.dart' show StateNotifier;
import 'package:rider_pay/view/home/data/model/ride_history_booking_model.dart';
import 'package:rider_pay/view/home/domain/repo/ride_booking_repo.dart';

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

  RideBookingNotifier(this.repo) : super(RideBookingState());

  Future<void> bookRide(Map<String, dynamic> payload) async {
    state = state.copyWith(isLoading: true,);
    try {
      final res = await repo.bookRide(payload);
      if(res["code"]==200){
        final rideID= res["data"]["ride_id"];
        state = state.copyWith(isLoading: false, rideId: rideID);

      }else{
        state = state.copyWith(isLoading: false, rideId: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, );
    }
  }


  Future<void> cancelRideApi(Map<String, dynamic> data) async {
   print("data cancelapi $data");
    state = state.copyWith(isLoading: true, );
    try {
      final res = await repo.cancelBooking(data);
      if(res["code"]==200){
        print(res);
        state = state.copyWith(isLoading: false);
      }else{
        state = state.copyWith(isLoading: false, rideId: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, );
    }
  }



  Future<void> rideHistoryApi(String userId) async {

    state = state.copyWith(isRideHistoryLoading: true, );
    try {
      final res = await repo.rideBookingHistoryApi(userId);
      if(res.code==200){
        state = state.copyWith(isRideHistoryLoading: false,bookingHistoryModelData: res);
      }else{
        state = state.copyWith(isRideHistoryLoading: false, bookingHistoryModelData: null);
      }
    } catch (e) {
      state = state.copyWith(isRideHistoryLoading: false, );
    }
  }
}
