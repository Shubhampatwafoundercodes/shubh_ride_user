// ignore: unused_import
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String token;
  final bool onBoardSeen;

  User({required this.id, required this.token,  this.onBoardSeen = false});
}

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  // Load from SharedPreferences (optional on app start)
  Future<void> loadUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.getString('userID');
    final token = sharedPreferences.getString('token');
    final isOnBoardSeen =
        sharedPreferences.getBool('isOnboardingSeen') ?? false;
    if (id != null && token != null) {
      state = User(id: id, token: token, onBoardSeen: isOnBoardSeen);
    } else {
      state = User(id: "", token: "", onBoardSeen: isOnBoardSeen);
    }
  }

  // Save user when OTP is verified
  Future<void> saveUser({required String id, required String token}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('userID', id);
    sharedPreferences.setString('token', token);
    final isOnBoardSeen = sharedPreferences.getBool('isOnboardingSeen') ?? false;

    state = User(id: id, token: token, onBoardSeen: isOnBoardSeen);
  }

  // Clear user (optional logout)
  Future<void> clearUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('userID');
    sharedPreferences.remove('token');
    state = null;
  }

  //onboard screen seen
  // onboarding_notifier.dart ya onboarding screen ke controller me
  Future<void> markOnboardingComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingSeen', true);
  }

  String? get token => state?.token;
  String? get userId => state?.id;
  bool get isOnboardingSeen => state?.onBoardSeen ?? false;
}

// Provider
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
