

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/helper/network/network_api_service_http.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/home/domain/repo/complete_payment_repo.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart';

import '../../data/repo_impl/complete_payment_repo_impl.dart';

/// 🔹 STATE CLASS
class CompletePaymentState {
  final bool isLoading;

  CompletePaymentState({
    required this.isLoading,
  });

  factory CompletePaymentState.initial() => CompletePaymentState(
    isLoading: false,
  );

  CompletePaymentState copyWith({
    bool? isLoading,
  }) {
    return CompletePaymentState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 🔹 PROVIDER
final completePaymentProvider =
StateNotifierProvider<CompletePaymentNotifier, CompletePaymentState>((ref) {
  final repo = CompletePaymentRepoImpl(NetworkApiServices(ref));
  return CompletePaymentNotifier(repo,ref);
});



/// 🔹 NOTIFIER CLASS
class CompletePaymentNotifier extends StateNotifier<CompletePaymentState> {
  final CompletePaymentRepo repo;
  final Ref ref;
  CompletePaymentNotifier(this.repo, this.ref) : super(CompletePaymentState.initial());

  Future<bool> completePaymentApi(String rideId,String finalFare) async {
    if (state.isLoading) return false;
    state = state.copyWith(isLoading: true);
    final profile=ref.read(profileProvider.notifier);
    final wallet=ref.read(walletProvider.notifier);
       Map data={
      "ride_id": rideId.toString(),
      "payment_method": "Wallet", // Options: "Cash", "Wallet", "UPI", "Card"
      "payment_status": "Paid",
         "final_fare":finalFare,

       };
    try {
      final res = await repo.completePaymentApi(data);
      if (res["code"] == 200) {
        profile.getProfile();
        wallet.getWalletHistory();
        state = state.copyWith(isLoading: false,);
        toastMsg(res["msg"]);
        return true;
      } else {
        state = state.copyWith(isLoading: false);
        toastMsg(res["msg"]);
        return false;
      }
    } catch (e) {
      print("❌ Error completing payment: $e");
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}
