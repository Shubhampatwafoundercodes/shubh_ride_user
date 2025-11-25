import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RideStep {
  vehicleList,
  // confirmPickupLocation,
  waitingForDriver,
}

@immutable
class RideFlowState {
  final List<RideStep> steps;
  final int selectedVehicleId;
  final double? selectedFare;
  final String selectedPaymentMethod;
  final double sheetExtent;

  const RideFlowState({
    this.steps = const [RideStep.vehicleList],
    this.selectedVehicleId = -1,
    this.selectedFare,
    this.selectedPaymentMethod = "Cash",
    this.sheetExtent = 0.3,
  });

  RideStep get currentStep => steps.last;

  RideFlowState copyWith({
    List<RideStep>? steps,
    int? selectedVehicleId,
    double? selectedFare,

    String? selectedPaymentMethod,
    double? sheetExtent,
  }) {
    return RideFlowState(
      steps: steps ?? this.steps,
      selectedVehicleId: selectedVehicleId ?? this.selectedVehicleId,
      selectedFare: selectedFare ?? this.selectedFare,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      sheetExtent: sheetExtent ?? this.sheetExtent,
    );
  }
}

class RideFlowController extends StateNotifier<RideFlowState> {
  RideFlowController() : super(const RideFlowState());

  /// Move to a new step
  void goTo(RideStep step) {
    state = state.copyWith(steps: [...state.steps, step]);
  }

  /// Go back one step
  void back() {
    if (state.steps.length > 1) {
      state = state.copyWith(
        steps: state.steps.sublist(0, state.steps.length - 1),
      );
    }
  }

  /// Replace current step with a new one
  void replaceWith(RideStep step) {
    state = state.copyWith(
      steps: [...state.steps.sublist(0, state.steps.length - 1), step],
    );
  }

  /// Force a step, clearing the history
  void forceStep(RideStep step) {
    state = state.copyWith(steps: [step]);
  }

  /// Select a vehicle
  void selectVehicle(int id, {required double fare}) {
    state = state.copyWith(
      selectedVehicleId: id,
      selectedFare: fare,
    );
  }
  void clearAll() {
    state = state.copyWith(
      selectedVehicleId: -1,
      selectedFare: null,
      selectedPaymentMethod: "Cash",
      steps: [RideStep.vehicleList],

    );
    debugPrint("🧹 Cleared all ride selections");
  }

  /// Select payment method
  void selectPayment(String method) {
    state = state.copyWith(selectedPaymentMethod: method);
    debugPrint("💳 Payment selected: $method");
  }

  /// Confirm booking
  Future<void> confirmBooking() async {
    if (state.selectedVehicleId == -1) {
      debugPrint("❌ Please select a vehicle before booking");
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    debugPrint("✅ Booking confirmed with vehicle: ${state.selectedVehicleId}, payment: ${state.selectedPaymentMethod}");
    replaceWith(RideStep.waitingForDriver);
  }



}

final rideFlowProvider =
StateNotifierProvider<RideFlowController, RideFlowState>(
      (ref) => RideFlowController(),
);
