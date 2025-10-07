class ReasonOfCancelModel {
  ReasonOfCancelModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final List<Datum> data;

  factory ReasonOfCancelModel.fromJson(Map<String, dynamic> json){
    return ReasonOfCancelModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}

class Datum {
  Datum({
    required this.id,
    required this.reason,
  });

  final int? id;
  final String? reason;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      reason: json["reason"],
    );
  }

}
