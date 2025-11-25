// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/view/home/domain/repo/profile_repo.dart';

class CmsState {
  final bool isLoading;
  final Map<String, dynamic>? pages;

  CmsState({this.isLoading = false, this.pages});

  CmsState copyWith({
    bool? isLoading,
    Map<String, dynamic>? pages,
  }) {
    return CmsState(
      isLoading: isLoading ?? this.isLoading,
      pages: pages,
    );
  }

  factory CmsState.initial() => CmsState();
}


class CmsNotifier extends StateNotifier<CmsState> {
  final ProfileRepo _repo;

  CmsNotifier(this._repo) : super(CmsState.initial());

  Future<void> getCmsTermConditionApi() async {
    state = state.copyWith(isLoading: true,);
    try {
      final res = await _repo.getCmsPages();
      if (res["code"] == 200) {
        state = state.copyWith(isLoading: false, pages: res["data"]);
      } else {
        state = state.copyWith(
          isLoading: false,
          // pages: null,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false,);
    }
  }
}
