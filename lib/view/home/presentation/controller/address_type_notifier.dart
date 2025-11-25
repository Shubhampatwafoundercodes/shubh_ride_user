import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/view/home/data/model/address_type_model.dart';
import 'package:rider_pay_user/view/home/domain/repo/address_type_repo.dart';

class AddressTypeState {
  final bool isLoading;
  final AddressTypeModel? types;

  AddressTypeState({
    this.isLoading = false,
    this.types ,
  });

  AddressTypeState copyWith({
    bool? isLoading,
    AddressTypeModel? types,
  }) {
    return AddressTypeState(
      isLoading: isLoading ?? this.isLoading,
      types: types ?? this.types,
    );
  }
}

class AddressTypeNotifier extends StateNotifier<AddressTypeState> {
  final AddressTypeRepo repo;

  AddressTypeNotifier(this.repo) : super(AddressTypeState());

  Future<void> loadAddressTypes() async {
    state = state.copyWith(isLoading: true,);
    try {
      final res = await repo.addressTypeApi();
      if(res.code==200){
        state = state.copyWith(isLoading: false, types: res);

      }
    } catch (e) {
      state = state.copyWith(isLoading: false, );
    }
  }
}
