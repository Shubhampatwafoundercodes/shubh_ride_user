import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String token;

  User({required this.id, required this.token});
}

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  // Load from SharedPreferences (optional on app start)
  Future<void> loadUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.getString('userID');
    final token = sharedPreferences.getString('token');
    if (id != null && token != null) {
      state = User(id: id, token: token);
    }
  }

  // Save user when OTP is verified
  Future<void> saveUser({required String id, required String token}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('userID', id);
    sharedPreferences.setString('token', token);
    state = User(id: id, token: token);
  }

  // Clear user (optional logout)
  Future<void> clearUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('userID');
    sharedPreferences.remove('token');
    state = null;
  }
  String? get token => state?.token;
  String? get userId => state?.id;

}

// Provider
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
