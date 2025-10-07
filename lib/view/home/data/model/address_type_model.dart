class AddressTypeModel {
  AddressTypeModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final List<Datum> data;

  factory AddressTypeModel.fromJson(Map<String, dynamic> json){
    return AddressTypeModel(
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
    required this.status,
    required this.icon,
    required this.createdAt,
  });

  final int? id;
  final String? name;
  final int? status;
  final String? icon;
  final DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      name: json["name"],
      status: json["status"],
      icon: json["icon"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

}
