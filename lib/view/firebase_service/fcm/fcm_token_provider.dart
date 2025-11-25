import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final fcmTokenProvider = StateNotifierProvider<FCMTokenNotifier, AsyncValue<String?>>((ref) {
  return FCMTokenNotifier();
});

class FCMTokenNotifier extends StateNotifier<AsyncValue<String?>> {
  FCMTokenNotifier() : super(const AsyncValue.data(null));

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _isInitialized = false;
  Future<String?> generateFCMToken() async {
    try {
      state = const AsyncValue.loading();

      // Ensure Firebase is initialized
      await Firebase.initializeApp();

      log('🔄 Generating FCM token...');
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        log('❌ Notifications permission denied');
        state = const AsyncValue.data(null);
        return null;
      }

      final token = await _messaging.getToken();
      if (token == null) {
        log('❌ FCM Token is still null');
        state = const AsyncValue.data(null);
        return null;
      }

      log('✅ FCM Token: $token');
      state = AsyncValue.data(token);

      if (!_isInitialized) {
        _messaging.onTokenRefresh.listen((newToken) {
          log('🔄 FCM Token refreshed: $newToken');
          state = AsyncValue.data(newToken);
        });
        _isInitialized = true;
      }

      return token;
    } catch (e, stack) {
      log('❌ FCM Token generation error: $e');
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  // Clear token when user logs out
  void clearToken() {
    log('🧹 Clearing FCM token on logout');
    state = const AsyncValue.data(null);
  }

  // Get current token without generating new one
  String? get currentToken {
    return state.valueOrNull;
  }
}