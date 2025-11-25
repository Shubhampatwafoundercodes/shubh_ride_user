import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/get_voucher_model.dart';
import '../../domain/repo/profile_repo.dart';
import '../../../share_pref/user_provider.dart';

class VoucherState {
  final bool isLoading;
  final GetVoucherModel? vouchers;

  VoucherState({this.isLoading = false,  this.vouchers});

  VoucherState copyWith({
    bool? isLoading,
    GetVoucherModel? vouchers,
  }) {
    return VoucherState(
      isLoading: isLoading ?? this.isLoading,
      vouchers: vouchers,
    );
  }

  factory VoucherState.initial() => VoucherState();
}

class VoucherNotifier extends StateNotifier<VoucherState> {
  final ProfileRepo _repo;
  final Ref ref;

  VoucherNotifier(this._repo, this.ref) : super(VoucherState.initial());

  Future<void> getVouchers() async {
    state = state.copyWith(isLoading: true, );
    try {
      final userId = ref.read(userProvider)?.id;
      if (userId == null) {
        state = state.copyWith(isLoading: false,);
        return;
      }
      final res = await _repo.getVoucherApi(userId);
      if(res.code==200){
        state = state.copyWith(isLoading: false, vouchers: res);

      }else{
        state = state.copyWith(isLoading: false, vouchers: null);

      }
    } catch (e) {
      state = state.copyWith(isLoading: false,);
    }
  }
}
