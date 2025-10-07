

import 'package:rider_pay/helper/network/base_api_service.dart';
import 'package:rider_pay/res/api_urls.dart';
import 'package:rider_pay/view/auth/data/model/login_responce.dart';
import 'package:rider_pay/view/auth/domain/repo/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BaseApiServices api;
  AuthRepositoryImpl(this.api);

  @override
  Future<AuthResponse> login(String phone) async {
    final url = ApiUrls.loginUrl;
    final body = {"phone": phone};
    final data = await api.getPostApiResponse(url, body);
    print(data);
    return AuthResponse.fromJson(data);
  }

  @override
  Future<dynamic> sendOtp(String phone) async {
    final url = ApiUrls.sendOtpUrl;
    final data = await api.getGetApiResponse(url+phone);
    print("shubhamm send otp field  $data , $url , $phone");
    return data;
  }

  @override
  Future<dynamic> verifyOtp(String phone, String otp) async {
    String url = '${ApiUrls.verifyOtpUrl}$phone&otp=$otp';
    print(url);
    final data = await api.getGetApiResponse(url);
    return data;
  }
  @override
  Future<dynamic> register(dynamic data) async {
    final res = await api.getPostApiResponse(ApiUrls.registerUrl,data);
    return res;
  }
}
