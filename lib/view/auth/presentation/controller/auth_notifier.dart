import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/auth/data/model/login_responce.dart';
import 'package:rider_pay_user/view/auth/domain/repo/auth_repo.dart';
import 'package:rider_pay_user/view/firebase_service/fcm/fcm_token_provider.dart';
import 'package:rider_pay_user/view/share_pref/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class AuthState {
  final bool isLoading;
  final AuthResponse? response;

  AuthState({required this.isLoading, this.response});

  factory AuthState.initial() => AuthState(isLoading: false);

  AuthState copyWith({bool? isLoading, AuthResponse? response, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final Ref ref;

  AuthNotifier(this._repo, this.ref) : super(AuthState.initial());
  void reset() {
    state = AuthState.initial();
  }

  Future<int> login(String phone) async {
    state = state.copyWith(isLoading: true, response: null);
    final fcmToken = await ref
        .read(fcmTokenProvider.notifier)
        .generateFCMToken();
    try {
      final res = await _repo.login(phone, fcmToken.toString());
      if (res.code == 200) {
        state = state.copyWith(isLoading: false, response: res);
        if (res.data!.isRegister == false) return 1;
        // if (res.data!.id != null && res.data!.token != null) return 2;


        if (res.data!.id != null && res.data!.token != null) {
          await ref.read(userProvider.notifier).saveUser(
            id: res.data!.id.toString(),
            token: res.data!.token.toString(),
          );

          return 2;

        }

      }
      return 3;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return 3;
    }
  }

  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true,);
    try {
      final res = await _repo.sendOtp(phone);
      if(res["error"]=="200"){
        state = state.copyWith(isLoading: false,);

        return true;

      }else{
        state = state.copyWith(isLoading: false,);

        return false;

      }
      // toastMsg(res["msg"].toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _repo.verifyOtp(phone, otp);

      state = state.copyWith(isLoading: false);

      final errorCode = res['error'].toString();
      if (errorCode == "200") {
        toastMsg(res["msg"] ?? "OTP Verified");

        // if (state.response?.data?.id != null && state.response?.data?.token != null) {
        //   final userId = state.response!.data!.id!;
        //   final token = state.response!.data!.token!;
        //
        //   await ref.read(userProvider.notifier).saveUser(id: userId.toString(), token: token);
        //
        //   final prefs = await SharedPreferences.getInstance();
        // } else {}

        return true;
      } else {
        toastMsg(res["msg"] ?? "OTP Verification Failed");
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      toastMsg("OTP Verification Error: $e");
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final res = await _repo.register(data);
      state = state.copyWith(isLoading: false);
      if (res['code'] == 200) {
        final token = res["data"]["token"].toString();
        final userId = res["data"]["user"]["id"].toString();
        await ref.read(userProvider.notifier).saveUser(id: userId, token: token);
        return true;
      } else {
        toastMsg(res["msg"].toString());
      }
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
