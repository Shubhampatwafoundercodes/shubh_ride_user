import 'package:rider_pay_user/view/firebase_service/ride/data/model/ride_booking_model.dart';

/// Abstract repository defining all Firestore ride operations
abstract class RideRepo {
  Future<void> bookRide(RideBookingModel ride);
  Future<void> deleteRide(String rideId);
  Stream<RideBookingModel?> listenToRideById(String rideId);
  Stream<Map<String, dynamic>?> listenToDriverLocationById(String driverId);
  Future<void> updateRideFields(String rideId, Map<String, dynamic> data);

  /// ✅ Driver-related
  // Future<String?> getDriverAvailability(String driverId);
  Future<Map<String, dynamic>?> getDriverDetails(String driverId);

  Future<Map<String, dynamic>?> getRideOnce(String rideId);


  Future<void> rejectDriverIfBusy(String rideId, String driverId);


  Future<void> updateDriverStatus(String rideId, String driverId,String driverStatus);


  Stream<List<Map<String, dynamic>>> listenToOnlineDrivers();







}