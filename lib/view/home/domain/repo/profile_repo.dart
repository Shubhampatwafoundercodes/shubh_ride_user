 import 'package:rider_pay/view/home/data/model/get_profile_model.dart';
import 'package:rider_pay/view/home/data/model/get_voucher_model.dart';

abstract class ProfileRepo {
  Future<GetProfileModel> getProfile(String userId);
  Future<dynamic> updateProfile(dynamic data);
  Future<dynamic> deleteAccountApi(String userId);

  Future<GetVoucherModel> getVoucherApi(String userId);

  Future<Map<String, dynamic>> getCmsPages();

}