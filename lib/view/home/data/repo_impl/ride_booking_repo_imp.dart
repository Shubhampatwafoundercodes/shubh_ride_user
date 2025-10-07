import 'package:rider_pay/helper/network/api_exception.dart';
import 'package:rider_pay/helper/network/base_api_service.dart';
import 'package:rider_pay/res/api_urls.dart';
import 'package:rider_pay/view/home/data/model/ride_history_booking_model.dart';
import 'package:rider_pay/view/home/domain/repo/ride_booking_repo.dart';

class RideBookingImp implements RideBookingRepo {
  final BaseApiServices api;

  RideBookingImp(this.api);

  @override
  Future<Map<String, dynamic>> bookRide(Map<String, dynamic> payload) async {
    try {
      final res = await api.getPostApiResponse(ApiUrls.rideBookingUrl, payload);
      return res;
    } catch (e) {
      throw AppException("Failed to book ride: $e");
    }
  }

  @override
  Future<Map<String, dynamic>> cancelBooking(Map<String, dynamic> data) async{
    try {
      final res = await api.getPostApiResponse(ApiUrls.cancelBookingUrl, data);
      return res;
    } catch (e) {
      throw AppException("Failed to cancelBooking: $e");
    }  }
  @override
  Future<RideBookingHistoryModel> rideBookingHistoryApi(String userId) async {
    try {
      final res = await api.getGetApiResponse(ApiUrls.rideBookingHistoryUrl+userId);
      return RideBookingHistoryModel.fromJson(res);
    } catch (e) {
      throw AppException("Failed to rideBookingHistoryApi: $e");
    }  }
}
