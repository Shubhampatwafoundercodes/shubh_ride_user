import 'package:rider_pay_user/view/home/data/model/ride_history_booking_model.dart';

abstract class RideBookingRepo {

 Future<Map<String, dynamic>> bookRide(Map<String, dynamic> payload);

 Future<Map<String, dynamic>> cancelBooking(Map<String, dynamic> data);

 Future<RideBookingHistoryModel> rideBookingHistoryApi(String userId);
}