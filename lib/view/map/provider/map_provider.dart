
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay/view/map/data/repositories/location_repository_imp.dart';
import 'package:rider_pay/view/map/data/repositories/map_repo_imp.dart';
import 'package:rider_pay/view/map/domain/repositories/location_repo.dart';
import 'package:rider_pay/view/map/presentation/controller/location_service_notifier.dart';
import 'package:rider_pay/view/map/presentation/controller/map_controller.dart';

import '../presentation/controller/map_notifier_provider.dart';

final locationServiceProvider =
StateNotifierProvider<LocationServiceNotifier, LocationState>(
      (ref) => LocationServiceNotifier(LocationRepositoryImpl()),
);


final locationRepositoryProvider = Provider<LocationRepository>(
      (ref) => LocationRepositoryImpl(),
);

// Map Controller provider
final mapControllerProvider =
StateNotifierProvider<MapController, MapState>((ref) {
  final repo = ref.watch(locationRepositoryProvider);
  return MapController(repo,ref);
});



// Map Provider for api
final mapNotifierProvider =
StateNotifierProvider<MapNotifier, MapNotifierState>((ref) {
  final repo = ref.watch(mapRepositoryProvider);
  return MapNotifier(repo,ref);
});