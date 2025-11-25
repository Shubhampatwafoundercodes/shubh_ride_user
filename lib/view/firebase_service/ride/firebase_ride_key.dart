// core/utils/firebase_keys.dart
class FirebaseRideKeys {
  static const collectionRides = 'rides';

  static const rideId = 'rideId';
  static const userId = 'userId';
  static const driverId = 'driverId';
  static const vehicleType = 'vehicleType';
  static const otp = 'otp';
  static const userNumber = 'userNumber';
  static const paymentMode = 'paymentMode';
  static const paymentStatus = 'paymentStatus';


  static const pickupLocation = 'pickupLocation'; // {lat, lng, address}
  static const dropLocation = 'dropLocation';     // {lat, lng, address}

  static const distanceKm = 'distanceKm';
  static const fare = 'fare';
  static const status = 'status';

  static const statusText = 'statusText';

  // static const bookedAt = 'bookedAt';
  // static const completedAt = 'completedAt';
  // static const cancelledAt = 'cancelledAt';

  static const String requestedDriverList = 'requestedDrivers';

  static const String rejectedDriversList = 'rejectedDrivers';

  // Driver-specific timestamps
  static const acceptedByDriver = 'acceptedByDriver';
  // static const acceptedAt = 'acceptedAt';
  // static const arrivedAt = 'arrivedAt';
  // static const pickedUpAt = 'pickedUpAt';
}
