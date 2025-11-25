class GetWalletHistoryModel {
  GetWalletHistoryModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final Data? data;

  factory GetWalletHistoryModel.fromJson(Map<String, dynamic> json){
    return GetWalletHistoryModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.wallet,
    required this.payinHistory,
  });

  final dynamic wallet;
  final List<PayinHistory>? payinHistory;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      wallet: json["wallet"],
      payinHistory: json["payinHistory"] == null
          ? []
          : List<PayinHistory>.from(json["payinHistory"]!.map((x) => PayinHistory.fromJson(x))),    );
  }

}

class PayinHistory {
  PayinHistory({
    required this.orderId,
    required this.amount,
    required this.status,
    required this.datetime,
  });

  final String? orderId;
  final dynamic amount;
  final String? status;
  final DateTime? datetime;

  factory PayinHistory.fromJson(Map<String, dynamic> json){
    return PayinHistory(
      orderId: json["orderId"],
      amount: json["amount"],
      status: json["status"],
      datetime: DateTime.tryParse(json["datetime"] ?? ""),
    );
  }

}
