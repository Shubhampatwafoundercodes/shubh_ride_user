class AppInfoModel {
  AppInfoModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final Data? data;

  factory AppInfoModel.fromJson(Map<String, dynamic> json){
    return AppInfoModel(
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
    required this.logo,
    required this.hashName,
    required this.status,
    required this.createdAt,
    required this.splashSliders,
    required this.homeSliders,
    required this.faqs,
    required this.userAppUrl,
    required this.driverAppUrl,
  });

  final int? id;
  final String? name;
  final String? logo;
  final String? hashName;
  final String? userAppUrl;
  final String? driverAppUrl;
  final int? status;
  final DateTime? createdAt;
  final List<SplashSlider> splashSliders;
  final List<HomeSlider> homeSliders;
  final List<Faq> faqs;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      name: json["name"],
      logo: json["logo"],
      hashName: json["hashName"],
      userAppUrl: json["userApplicationUrl"],
      driverAppUrl: json["driverApplicationUrl"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      splashSliders: json["splashSliders"] == null ? [] : List<SplashSlider>.from(json["splashSliders"]!.map((x) => SplashSlider.fromJson(x))),
      homeSliders: json["homeSliders"] == null ? [] : List<HomeSlider>.from(json["homeSliders"]!.map((x) => HomeSlider.fromJson(x))),
      faqs: json["faqs"] == null ? [] : List<Faq>.from(json["faqs"]!.map((x) => Faq.fromJson(x))),
    );
  }

}

class Faq {
  Faq({
    required this.id,
    required this.question,
    required this.answer,
  });

  final int? id;
  final String? question;
  final String? answer;

  factory Faq.fromJson(Map<String, dynamic> json){
    return Faq(
      id: json["id"],
      question: json["question"],
      answer: json["answer"],
    );
  }

}

class HomeSlider {
  HomeSlider({
    required this.id,
    required this.imageUrl,
    required this.sortOrder,
    required this.status,
  });

  final int? id;
  final String? imageUrl;
  final int? sortOrder;
  final int? status;

  factory HomeSlider.fromJson(Map<String, dynamic> json){
    return HomeSlider(
      id: json["id"],
      imageUrl: json["image_url"],
      sortOrder: json["sort_order"],
      status: json["status"],
    );
  }

}

class SplashSlider {
  SplashSlider({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.sortOrder,
    required this.status,
  });

  final int? id;
  final String? imageUrl;
  final String? title;
  final String? subTitle;
  final int? sortOrder;
  final int? status;

  factory SplashSlider.fromJson(Map<String, dynamic> json){
    return SplashSlider(
      id: json["id"],
      imageUrl: json["image_url"],
      title: json["titel"],
      subTitle: json["subTitel"],
      sortOrder: json["sort_order"],
      status: json["status"],
    );
  }

}
