import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/res/format/date_time_formater.dart';
import 'package:rider_pay_user/view/home/data/model/get_profile_model.dart';
import 'package:rider_pay_user/view/home/domain/repo/profile_repo.dart';
import 'package:rider_pay_user/view/share_pref/user_provider.dart';

class ProfileState {
  final bool isLoadingProfile;
  final bool isUpdatingProfile;
  final bool isDeletingAccount;
  final GetProfileModel? profile;

  ProfileState({
    this.isLoadingProfile = false,
    this.isUpdatingProfile = false,
    this.isDeletingAccount = false,
    this.profile,
  });

  ProfileState copyWith({
    bool? isLoadingProfile,
    bool? isUpdatingProfile,
    bool? isDeletingAccount,
    GetProfileModel? profile,
  }) {
    return ProfileState(
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      profile: profile,
    );
  }

  factory ProfileState.initial() => ProfileState();
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepo _repo;
  final Ref ref;

  ProfileNotifier(this._repo, this.ref) : super(ProfileState.initial());

  /// 🔹 Get Profile
  Future<void> getProfile() async {
    state = state.copyWith(isLoadingProfile: true,);
    try {
      final userId = ref.read(userProvider)?.id;
      if (userId == null) {
        state = state.copyWith(isLoadingProfile: false, );
        return;
      }
      final res = await _repo.getProfile(userId);
      if (res.code == 200) {
        state = state.copyWith(isLoadingProfile: false, profile: res);
      } else {
        // state = state.copyWith(isLoadingProfile: false,profile: null );
        state = state.copyWith(isLoadingProfile: false, );

      }

    } catch (e) {
      state = state.copyWith(isLoadingProfile: false, );
    }
  }

  /// 🔹 Update Profile
  Future<void> updateProfileField(String key, String value) async {
    state = state.copyWith(isUpdatingProfile: true,);
    try {
      // API call ke liye sirf updated field bhej rahe
      final res = await _repo.updateProfile({key: value});
      if (res["code"] == 200) {
        getProfile();
        state = state.copyWith(isUpdatingProfile: false,);
      } else {
        state = state.copyWith(isUpdatingProfile: false, );
      }
    } catch (e) {
      state = state.copyWith(isUpdatingProfile: false,);
    }
  }

  /// 🔹 Delete Account
  Future<void> deleteAccount() async {
    state = state.copyWith(isDeletingAccount: true, );
    try {
      final userId = ref.read(userProvider)?.id;
      if (userId == null) {
        state = state.copyWith(isDeletingAccount: false,);
        return;
      }
      await _repo.deleteAccountApi(userId);
      state = state.copyWith(isDeletingAccount: false, profile: null);
    } catch (e) {
      state = state.copyWith(isDeletingAccount: false,);
    }
  }

  /// 🔹 Safe getters
  String get name => state.profile?.data?.name ?? "N/A";
  String get phone => state.profile?.data?.phone ?? "N/A";
  String get email => state.profile?.data?.email ?? "N/A";
  String get gender => state.profile?.data?.gender ?? "N/A";
  String get dob {
    final dobStr = state.profile?.data?.dob;
    if (dobStr == null) return "--";
    try {
      return DateTimeFormat.formatDate(dobStr.toString());
    } catch (_) {
      return "--";
    }
  }

  String get profilePic => state.profile?.data?.profile ?? "";
  String get emergencyContact => state.profile?.data?.emergencyContact??"";
  String get inviteCode => state.profile?.data?.inviteCode ?? "--";
  int get otp => state.profile?.data?.otp ?? 1234;
  String get memberSince {
    final created = state.profile?.data?.createdAt;
    if (created == null) return "--";
    try {
      return DateTimeFormat.formatFullDateTime(created.toString());
    } catch (_) {
      return "--";
    }
  }
}
