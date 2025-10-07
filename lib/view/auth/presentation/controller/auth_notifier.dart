import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay/utils/utils.dart';
import 'package:rider_pay/view/auth/data/model/login_responce.dart';
import 'package:rider_pay/view/auth/domain/repo/auth_repo.dart';
import 'package:rider_pay/view/share_pref/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

class AuthState {
  final bool isLoading;
  final AuthResponse? response;

  AuthState({required this.isLoading, this.response,});

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

  // Future<int> login(String phone) async {
  //   // navigation status = 1- register screen, 2- home screen, 3- error state no navigation
  //   state = state.copyWith(isLoading: true, error: null);
  //   try {
  //     final res = await _repo.login(phone);
  //     if (res.code == 200) {
  //       if (res.data!.isRegister != null && res.data!.isRegister == false) {
  //         return 1;
  //       } else if (res.data!.id != null && res.data!.token != null) {
  //         return 2;
  //       } else {
  //         return 3;
  //       }
  //     } else {
  //       return 3;
  //     }
  //     state = state.copyWith(isLoading: false, response: res);
  //   } catch (e) {
  //     state = state.copyWith(isLoading: false, error: e.toString());
  //     return 3;
  //   }
  // }
  Future<int> login(String phone) async {
    print("SHubham2222222");
    state = state.copyWith(isLoading: true,  response: null);
    try {
      final res = await _repo.login(phone);
      print("SHubham2222222 $res");
      if (res.code == 200) {
        print("SHubham2222223 $res");
        state = state.copyWith(isLoading: false, response: res);
        if (res.data!.isRegister == false) return 1;
        if (res.data!.id != null && res.data!.token != null) return 2;
      }
      return 3;
    } catch (e) {
      state = state.copyWith(isLoading: false, );
      return 3;
    }
  }



  Future<void> sendOtp(String phone) async {
    print("hgvhhhhhhhhhhhhhhh $phone");
    // state = state.copyWith(isLoading: true,);
    try {
      final res = await _repo.sendOtp(phone);
      print("otppppppppp $res");
      toastMsg(res["msg"].toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, );
      debugPrint(e.toString());
    }
  }

  // Future<bool> verifyOtp(String phone, String otp) async {
  //   state = state.copyWith(isLoading: true, error: null);
  //   try {
  //     final res = await _repo.verifyOtp(phone, otp);
  //          print(res);
  //     state = state.copyWith(isLoading: false);
  //     if (res['error'] == 200) {
  //       toastMsg(res["msg"] ?? "OTP Verified");
  //       if (state.response?.data?.id != null && state.response?.data?.token != null) {
  //         await ref.read(userProvider.notifier).saveUser(id: res.data!.id!, token: res.data!.token!);
  //       }
  //       return true;
  //     }else{
  //       toastMsg(res["msg"] ?? "OTP Verification Failed");
  //       return false;
  //     }
  //
  //
  //   } catch (e) {
  //     state = state.copyWith(isLoading: false, error: e.toString());
  //     toastMsg("OTP Verification Error: $e");
  //     return false;
  //   }
  // }


  Future<bool> verifyOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print("📩 Sending verifyOtp request => phone: $phone, otp: $otp");
      final res = await _repo.verifyOtp(phone, otp);
      print("✅ API Response => $res");

      state = state.copyWith(isLoading: false);

      final errorCode = res['error'].toString();
      if (errorCode == "200") {
        toastMsg(res["msg"] ?? "OTP Verified");

        // 🔍 Debug: state ka response print karo
        print("🔍 state.response => ${state.response?.toJson()}");

        if (state.response?.data?.id != null && state.response?.data?.token != null) {
          final userId = state.response!.data!.id!;
          final token = state.response!.data!.token!;

          print("🆔 userId => $userId");
          print("🔑 token => $token");

          await ref.read(userProvider.notifier).saveUser(
            id: userId.toString(),
            token: token,
          );

          final prefs = await SharedPreferences.getInstance();
          print("📦 Saved in SharedPrefs => userId: ${prefs.getString("userID")}, token: ${prefs.getString("token")}");
        } else {
          print("⚠️ state.response.data null hai (id ya token missing)");
        }

        return true;
      } else {
        toastMsg(res["msg"] ?? "OTP Verification Failed");
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false,);
      toastMsg("OTP Verification Error: $e");
      print("❌ Exception => $e");
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _repo.register(data);
      print("register $res");
      state = state.copyWith(isLoading: false);
      if (res['code'] == 200) {
        print("register1 $res");
        final token = res["data"]["token"];
        final userId = res["data"]["user"]["id"].toString();
        await ref.read(userProvider.notifier).saveUser(
          id: userId,
          token: token,
        );        toastMsg(res["msg"].toString());
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
