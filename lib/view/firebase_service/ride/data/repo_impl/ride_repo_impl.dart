import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
// ignore: unused_import
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/firebase_service/ride/data/model/ride_booking_model.dart';
import 'package:rider_pay_user/view/firebase_service/ride/domain/ride_repo.dart';
import 'package:rider_pay_user/view/firebase_service/ride/firebase_ride_key.dart';

class RideRepoImpl implements RideRepo {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> bookRide(RideBookingModel ride) async {
    await _firestore.collection(FirebaseRideKeys.collectionRides).doc(
        ride.rideId).set({
      ...ride.toMap(),
      FirebaseRideKeys.status: 'pending',
    });
  }

  @override
  Future<void> updateRideFields(String rideId,
      Map<String, dynamic> data) async {
    await _firestore.collection(FirebaseRideKeys.collectionRides)
        .doc(rideId)
        .update(data);
  }

  @override
  Stream<RideBookingModel?> listenToRideById(String rideId) async* {
    final rideRef = _firestore.collection(FirebaseRideKeys.collectionRides).doc(
        rideId);
    await for (final doc in rideRef.snapshots()) {
      if (!doc.exists) {
        yield null;
        continue;
      }
      final ride = RideBookingModel.fromMap({
        ...doc.data()!,
        FirebaseRideKeys.rideId: doc.id,
      });
      yield ride;
    }
  }

  @override
  Future<void> deleteRide(String rideId) async {
    await _firestore.collection(FirebaseRideKeys.collectionRides)
        .doc(rideId)
        .delete();
  }


  @override
  Future<Map<String, dynamic>?> getDriverDetails(String driverId) async {
    try {
      final doc = await _firestore.collection('drivers').doc(driverId).get();
      if (!doc.exists) return null;
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> rejectDriverIfBusy(String rideId, String driverId) async {
    final doc = _firestore.collection(FirebaseRideKeys.collectionRides).doc(
        rideId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(doc);
      if (!snap.exists) return;

      final data = snap.data() ?? {};
      final List<dynamic> requested = List.from(data['requestedDrivers'] ?? []);
      final List<dynamic> rejected = List.from(data['rejectedDrivers'] ?? []);

      requested.removeWhere((d) => d['id'] == driverId);
      if (!rejected.contains(driverId)) rejected.add(driverId);

      tx.update(doc, {
        'requestedDrivers': requested,
        'rejectedDrivers': rejected,
      });
    });
  }

  @override
  Future<Map<String, dynamic>?> getRideOnce(String rideId) async {
    try {
      final doc = await _firestore.collection(FirebaseRideKeys.collectionRides)
          .doc(rideId)
          .get();
      if (!doc.exists) {
        debugPrint("❌ Ride not found in Firebase: $rideId");
        return null;
      }
      debugPrint("✅ Ride fetched from Firebase → ${doc.data()}");
      return doc.data();
    } catch (e) {
      debugPrint("❌ getRideOnce error: $e");
      return null;
    }
  }



  @override
  Future<void> updateDriverStatus(String rideId, String driverId,
      String driverStatus) async
  {
    final driverRef = _firestore.collection('drivers').doc(driverId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(driverRef);
      if (!snap.exists) return;
      final data = snap.data() ?? {};
      final availability = (data['availability'] ?? 'offline').toString().toLowerCase();
      if (availability != 'online') {
        throw Exception("Driver $driverId not available");
      }
      tx.update(driverRef, {
        'availability': driverStatus,
        'currentRideId': rideId,
        'last_active': DateTime.now().toIso8601String(),
      });
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> listenToOnlineDrivers() {
    return _firestore.collection('drivers')
        .where('availability', isEqualTo: 'Online')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final driverDetails = data['driverDetails'] ?? {};
        return {
          "id": doc.id,
          "latitude": data['location']?['latitude'],
          "longitude": data['location']?['longitude'],
          "vehicleType": (driverDetails['vehicleType'] ?? "Unknown").toString(),
        };
      }).toList();
    });
  }



  @override
  Stream<Map<String, dynamic>?> listenToDriverLocationById(String driverId) {
    return _firestore.collection("drivers").doc(driverId).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null || data["location"] == null) return null;

      final loc = data["location"] as Map<String, dynamic>;
      return {
        "latitude": loc["latitude"],
        "longitude": loc["longitude"],
        "updatedAt": loc["updatedAt"],
        "availability": data["availability"],
        "vehicleType": data["vehicleType"],
      };
    });
  }
}
