


class AuthResponse {
  int? code;
  String? msg;
  Data? data;

  AuthResponse({this.code, this.msg, this.data});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? token;
  int? id;
  bool? isRegister;

  Data({this.token, this.id, this.isRegister});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    isRegister = json['isRegister'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] =
        token;
    data['id'] = id;
    data['isRegister'] = isRegister;
    return data;
  }
}
