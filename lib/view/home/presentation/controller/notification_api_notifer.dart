import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/helper/network/network_api_service_http.dart';
import 'package:rider_pay_user/view/home/data/model/notification_model.dart';
import 'package:rider_pay_user/view/home/data/repo_impl/notification_repo_impl.dart';
import 'package:rider_pay_user/view/home/domain/repo/notification_repo.dart';
import 'package:rider_pay_user/view/share_pref/user_provider.dart';

class NotificationApiState {
  final bool isLoading;
  final NotificationModel? notificationModelData;

  NotificationApiState({
    this.isLoading = false,
    this.notificationModelData,
  });

  NotificationApiState copyWith({
    bool? isLoading,
    NotificationModel? notificationModelData,
  }) {
    return NotificationApiState(
      isLoading: isLoading ?? this.isLoading,
      notificationModelData: notificationModelData ?? this.notificationModelData,
    );
  }
}

class NotificationApiNotifier extends StateNotifier<NotificationApiState> {
  final NotificationRepo repo;
  final Ref ref;

  NotificationApiNotifier(this.repo, this.ref) : super(NotificationApiState());

  Future<void> notificationApi() async {
    state = state.copyWith(isLoading: true);
    final userId = ref.read(userProvider.notifier).userId;

    try {
      final res = await repo.notificationApi(userId.toString(), "1");
      if (res.code == 200) {
        state = state.copyWith(
          isLoading: false,
          notificationModelData: res,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final notificationApiProvider =
StateNotifierProvider<NotificationApiNotifier, NotificationApiState>(
      (ref) => NotificationApiNotifier(NotificationRepoImpl(NetworkApiServices(ref)), ref),
);
