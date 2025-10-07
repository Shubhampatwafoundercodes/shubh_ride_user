import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay/view/home/data/model/reson_of_cancel_model.dart';
import 'package:rider_pay/view/home/domain/repo/reason_of_cancel_repo.dart';

class ReasonOfCancelState {
  final bool isLoading;
  final ReasonOfCancelModel? reasons;

  ReasonOfCancelState({
    this.isLoading = false,
    this.reasons,
  });

  ReasonOfCancelState copyWith({
    bool? isLoading,
    ReasonOfCancelModel? reasons,
  }) {
    return ReasonOfCancelState(
      isLoading: isLoading ?? this.isLoading,
      reasons: reasons ?? this.reasons,
    );
  }
}


class ReasonOfCancelNotifier extends StateNotifier<ReasonOfCancelState> {
  final ReasonOfCancelRepo repo;

  ReasonOfCancelNotifier(this.repo) : super(ReasonOfCancelState());

  Future<void> loadReasonsApi() async {
    state = state.copyWith(isLoading: true, );
    try {
      final res = await repo.reasonOfCancelApi();
      if (res.code == 200) {
        state = state.copyWith(isLoading: false, reasons: res);
      } else {
        state = state.copyWith(
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, );
    }
  }
}
