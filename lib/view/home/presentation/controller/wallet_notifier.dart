import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay/view/home/data/model/wallet_data_model.dart';
import 'package:rider_pay/view/home/domain/repo/wallet_repo.dart';
import 'package:rider_pay/view/share_pref/user_provider.dart';

class WalletState {
  final bool isLoading;
  final WalletDataModel? walletData;

  WalletState({
    required this.isLoading,
    this.walletData,
  });

  factory WalletState.initial() => WalletState(isLoading: false, walletData: null, );

  WalletState copyWith({
    bool? isLoading,
    WalletDataModel? walletData,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      walletData: walletData ,
    );
  }
}


class WalletNotifier extends StateNotifier<WalletState> {
  final WalletRepo _repo;
  final Ref ref;


  WalletNotifier(this._repo, this.ref,) : super(WalletState.initial());

  Future<void> getWalletHistory() async {
    state = state.copyWith(isLoading: true,);
    try {
      final userId = ref.read(userProvider)?.id;
      if (userId == null) {
        state = state.copyWith(isLoading: false,);
        return;
      }
      final data = await _repo.getWalletHistoryApi(userId.toString());
      if(data.code==200){
        state = state.copyWith(isLoading: false, walletData: data);
      }else{
        state = state.copyWith(isLoading: false, walletData: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false,);
    }
  }

  double get walletAmount => state.walletData?.data?.wallet ?? 0.0;
}
