import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NetworkStatus { connected, disconnected }

final networkStatusProvider =
StateNotifierProvider<NetworkStatusNotifier, NetworkStatus>(
      (ref) => NetworkStatusNotifier(),
);

class NetworkStatusNotifier extends StateNotifier<NetworkStatus> {
  late StreamSubscription _subscription;

  NetworkStatusNotifier() : super(NetworkStatus.connected) {
    _init();
  }

  Future<void> _init() async {
    final connectivity = Connectivity();

    final results = await connectivity.checkConnectivity();
    state = _getStatusFromResults(results);

    _subscription =
        connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
          state = _getStatusFromResults(results);
        });
  }

  NetworkStatus _getStatusFromResults(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.vpn)) {
      return NetworkStatus.connected;
    }
    return NetworkStatus.disconnected;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
