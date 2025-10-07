class WalletDataModel {
  WalletDataModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final Data? data;

  factory WalletDataModel.fromJson(Map<String, dynamic> json){
    return WalletDataModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.wallet,
  });

  dynamic wallet;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      wallet: json["wallet"],
    );
  }

}
