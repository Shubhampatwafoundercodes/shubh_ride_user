import 'package:rider_pay_user/view/auth/data/model/login_responce.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String phone,String fcmToken);

  Future<dynamic> sendOtp(String phone);

  Future<dynamic> verifyOtp(String phone, String otp);

  Future<dynamic> register(dynamic data);
}