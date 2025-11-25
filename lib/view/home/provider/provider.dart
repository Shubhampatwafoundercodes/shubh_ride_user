import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/helper/network/network_api_service_http.dart';
import 'package:rider_pay_user/view/home/data/repo_impl/address_type_repo_impl.dart';
import 'package:rider_pay_user/view/home/data/repo_impl/app_info_impl.dart';
import 'package:rider_pay_user/view/home/data/repo_impl/profile_repo_imp.dart';
import 'package:rider_pay_user/view/home/data/repo_impl/reason_of_cancel_imp.dart';
import 'package:rider_pay_user/view/home/data/repo_impl/ride_booking_repo_imp.dart';
import 'package:rider_pay_user/view/home/data/repo_impl/vehicle_type_repo_impl.dart';
import 'package:rider_pay_user/view/home/data/repo_impl/wallet_repo_imp.dart';
import 'package:rider_pay_user/view/home/domain/repo/address_type_repo.dart';
import 'package:rider_pay_user/view/home/domain/repo/app_Info_repo.dart';
import 'package:rider_pay_user/view/home/presentation/controller/address_type_notifier.dart';
import 'package:rider_pay_user/view/home/presentation/controller/app_info_notifier.dart';
import 'package:rider_pay_user/view/home/presentation/controller/cms_term_conditon_notifer.dart';
import 'package:rider_pay_user/view/home/presentation/controller/profile_notifier.dart';
import 'package:rider_pay_user/view/home/presentation/controller/reason_of_cancel_notifier.dart';
import 'package:rider_pay_user/view/home/presentation/controller/ride_booking_notifier.dart';
import 'package:rider_pay_user/view/home/presentation/controller/vehicle_type_notifier.dart';
import 'package:rider_pay_user/view/home/presentation/controller/voucher_notifer.dart';
import 'package:rider_pay_user/view/home/presentation/controller/wallet_notifier.dart';
/// app info api
final appInfoRepoProvider = Provider<AppInfoRepo>((ref) {
  return AppInfoImpl(NetworkApiServices(ref));
});

final appInfoNotifierProvider =
  StateNotifierProvider<AppInfoNotifier, AppInfoState>((ref) {
  final repo = ref.read(appInfoRepoProvider);
  return AppInfoNotifier(repo);
});


///address type imp
final addressTypeRepoProvider = Provider<AddressTypeRepo>((ref) {
  return AddressTypeRepoImpl(NetworkApiServices(ref));
});
final addressTypeNotifierProvider =
StateNotifierProvider<AddressTypeNotifier, AddressTypeState>((ref) {
  final repo = ref.watch(addressTypeRepoProvider); // repo provider
  return AddressTypeNotifier(repo);
});


/// profile provider
///address type imp
// final profileRepoProvider = Provider<ProfileRepo>((ref) {
//   return ProfileRepoImp(NetworkApiServices(ref));
// });
// final profileProvider =
// StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
//   final repo = ref.watch(profileRepoProvider);
//   return ProfileNotifier(repo, ref);
// });
final profileProvider =
StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ProfileRepoImp(NetworkApiServices(ref)), ref);
});


/// voucher api provider

final voucherProvider =
StateNotifierProvider<VoucherNotifier, VoucherState>((ref) {
  return VoucherNotifier(ProfileRepoImp(NetworkApiServices(ref)), ref);
});

/// term & condition and safety api
final cmsProvider = StateNotifierProvider<CmsNotifier, CmsState>((ref) {
  return CmsNotifier(ProfileRepoImp(NetworkApiServices(ref)));
});

/// wallet  section provider

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier(WalletRepoImp(NetworkApiServices(ref)), ref);
});


/// vehicle type provider

final vehicleTypeProvider = StateNotifierProvider<VehicleTypeNotifier, VehicleTypeState>((ref) {
  return VehicleTypeNotifier(VehicleTypeRepoImpl((NetworkApiServices(ref))));
});


/// reason of cancel
final reasonOfCancelProvider =
StateNotifierProvider<ReasonOfCancelNotifier, ReasonOfCancelState>(
      (ref) => ReasonOfCancelNotifier(ReasonOfCancelImp((NetworkApiServices(ref)))),
);

/// confirm Booking provider
final rideBookingProvider =
StateNotifierProvider<RideBookingNotifier, RideBookingState>(
      (ref) => RideBookingNotifier(RideBookingImp((NetworkApiServices(ref))),ref),
);