class GetProfileModel {
  GetProfileModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final Data? data;

  factory GetProfileModel.fromJson(Map<String, dynamic> json){
    return GetProfileModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.otp,
    required this.dob,
    required this.emergencyContact,
    required this.inviteCode,
    required this.profile,
    required this.createdAt,
    required this.currentToken,
    required this.savedAddress,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final int? otp;
  final DateTime? dob;
  final String? emergencyContact;
  final String? inviteCode;
  final String? profile;
  final DateTime? createdAt;
  final dynamic currentToken;
  final List<SavedAddress> savedAddress;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      gender: json["gender"],
      otp: json["otp"],
      dob: DateTime.tryParse(json["dob"] ?? ""),
      emergencyContact: json["emergencyContact"],
      inviteCode: json["inviteCode"],
      profile: json["profile"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      currentToken: json["current_token"],
      savedAddress: json["savedAddress"] == null ? [] : List<SavedAddress>.from(json["savedAddress"]!.map((x) => SavedAddress.fromJson(x))),
    );
  }

}

class SavedAddress {
  SavedAddress({
    required this.id,
    required this.userId,
    required this.addressType,
    required this.name,
    required this.address,
    required this.letitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    required this.type,
    required this.typeIcon,
  });

  final int? id;
  final int? userId;
  final int? addressType;
  final String? name;
  final String? address;
  final String? letitude;
  final String? longitude;
  final int? status;
  final DateTime? createdAt;
  final String? type;
  final String? typeIcon;

  factory SavedAddress.fromJson(Map<String, dynamic> json){
    return SavedAddress(
      id: json["id"],
      userId: json["userId"],
      addressType: json["address_type"],
      name: json["name"],
      address: json["address"],
      letitude: json["letitude"],
      longitude: json["longitude"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      type: json["type"],
      typeIcon: json["typeIcon"],
    );
  }

}
