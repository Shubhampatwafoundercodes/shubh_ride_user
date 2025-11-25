class NotificationModel {
  NotificationModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final List<Datum> data;

  factory NotificationModel.fromJson(Map<String, dynamic> json){
    return NotificationModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.userType,
    required this.title,
    required this.description,
    required this.datetime,
  });

  final int? id;
  final int? userId;
  final int? userType;
  final String? title;
  final String? description;
  final DateTime? datetime;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      userId: json["userId"],
      userType: json["userType"],
      title: json["title"],
      description: json["description"],
      datetime: DateTime.tryParse(json["datetime"] ?? ""),
    );
  }

}
