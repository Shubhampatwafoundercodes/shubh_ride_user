class VehicleTypeModel {
  VehicleTypeModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final List<Datum> data;

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json){
    return VehicleTypeModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.description,
    required this.baseFare,
    required this.perKmRate,
    required this.perMinuteRate,
    required this.capacity,
    required this.icon,
    required this.awayMinuts,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? description;
  final String? baseFare;
  final String? perKmRate;
  final String? perMinuteRate;
  final int? capacity;
  final String? icon;
  final String? awayMinuts;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      baseFare: json["base_fare"],
      perKmRate: json["per_km_rate"],
      perMinuteRate: json["per_minute_rate"],
      capacity: json["capacity"],
      icon: json["icon"],
      awayMinuts: json["awayMinutes"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}
