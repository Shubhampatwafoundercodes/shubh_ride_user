class GetVoucherModel {
  GetVoucherModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final Data? data;

  factory GetVoucherModel.fromJson(Map<String, dynamic> json){
    return GetVoucherModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.vouchers,
    required this.totalAmount,
  });

  final List<Voucher> vouchers;
  final int? totalAmount;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      vouchers: json["vouchers"] == null ? [] : List<Voucher>.from(json["vouchers"]!.map((x) => Voucher.fromJson(x))),
      totalAmount: json["totalAmount"],
    );
  }

}

class Voucher {
  Voucher({
    required this.id,
    required this.code,
    required this.description,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  final int? id;
  final dynamic code;
  final String? description;
  dynamic amount;
  final String? status;
  final DateTime? createdAt;

  factory Voucher.fromJson(Map<String, dynamic> json){
    return Voucher(
      id: json["id"],
      code: json["code"],
      description: json["description"],
      amount: json["amount"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

}
