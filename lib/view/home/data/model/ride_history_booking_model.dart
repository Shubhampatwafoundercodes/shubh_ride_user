class RideBookingHistoryModel {
  RideBookingHistoryModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final Data? data;

  factory RideBookingHistoryModel.fromJson(Map<String, dynamic> json){
    return RideBookingHistoryModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.data,
    required this.pending,
  });

  final List<RideHistorySingleDataModel> data;
  final RideHistorySingleDataModel? pending;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      data: json["data"] == null ? [] : List<RideHistorySingleDataModel>.from(json["data"]!.map((x) => RideHistorySingleDataModel.fromJson(x))),
      pending: json["pending"] == null ? null : RideHistorySingleDataModel.fromJson(json["pending"]),
    );
  }

}

class RideHistorySingleDataModel {
  RideHistorySingleDataModel({
    required this.rideId,
    required this.bookingTime,
    required this.finalFare,
    required this.status,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropAddress,
    required this.dropLat,
    required this.dropLng,
    required this.distanceKm,
    required this.suggestFare,
    required this.name,
    required this.blackWhiteIcon,
  });

  final String? rideId;
  final DateTime? bookingTime;
  final String? finalFare;
  final String? status;
  final String? pickupAddress;
  final String? pickupLat;
  final String? pickupLng;
  final String? dropAddress;
  final String? dropLat;
  final String? dropLng;
  final String? distanceKm;
  final String? suggestFare;
  final String? name;
  final String? blackWhiteIcon;

  factory RideHistorySingleDataModel.fromJson(Map<String, dynamic> json){
    return RideHistorySingleDataModel(
      rideId: json["ride_id"],
      bookingTime: DateTime.tryParse(json["booking_time"] ?? ""),
      finalFare: json["final_fare"],
      status: json["status"],
      pickupAddress: json["pickup_address"],
      pickupLat: json["pickup_lat"],
      pickupLng: json["pickup_lng"],
      dropAddress: json["drop_address"],
      dropLat: json["drop_lat"],
      dropLng: json["drop_lng"],
      distanceKm: json["distance_km"],
      suggestFare: json["suggestFare"],
      name: json["name"],
      blackWhiteIcon: json["blackWhiteIcon"],
    );
  }

}
