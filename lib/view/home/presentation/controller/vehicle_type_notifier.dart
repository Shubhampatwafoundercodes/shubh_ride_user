import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay/view/home/data/model/vehicle_type_model.dart';
import 'package:rider_pay/view/home/domain/repo/vehicle_type_repo.dart';

class VehicleTypeState {
  final bool isLoading;
  final VehicleTypeModel? vehicleTypeModelData;

  VehicleTypeState({
    required this.isLoading,
    this.vehicleTypeModelData,
  });

  factory VehicleTypeState.initial() => VehicleTypeState(
    isLoading: false,
    vehicleTypeModelData: null,
  );
  VehicleTypeState copyWith({
    bool? isLoading,
    VehicleTypeModel? vehicleTypeModelData,
  }) {
    return VehicleTypeState(
      isLoading: isLoading ?? this.isLoading,

      vehicleTypeModelData: vehicleTypeModelData,
    );
  }
}

class VehicleTypeNotifier extends StateNotifier<VehicleTypeState> {
  final VehicleTypeRepo repo;
  VehicleTypeNotifier(this.repo) : super(VehicleTypeState.initial());

  Future<void> fetchVehicleTypes() async {
    state = state.copyWith(isLoading: true, );

    try {
      final result = await repo.vehicleTypeApi();
      if (result.code == 200) {
        state = state.copyWith(isLoading: false, vehicleTypeModelData: result);
      } else {
        state = state.copyWith(isLoading: false, vehicleTypeModelData: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, );
    }
  }
}
