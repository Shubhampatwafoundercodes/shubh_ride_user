import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider, StateNotifierProvider;
import 'package:rider_pay_user/helper/network/network_api_service_http.dart';
import 'package:rider_pay_user/view/auth/data/repo/auth_repo_imp.dart';
import 'package:rider_pay_user/view/auth/domain/repo/auth_repo.dart';
import 'package:rider_pay_user/view/auth/presentation/controller/auth_notifier.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(NetworkApiServices(ref));
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthNotifier(repo, ref);
});
