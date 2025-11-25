import 'package:rider_pay_user/helper/network/base_api_service.dart';
import 'package:rider_pay_user/res/api_urls.dart';
import 'package:rider_pay_user/view/home/data/model/get_profile_model.dart';
import 'package:rider_pay_user/view/home/data/model/get_voucher_model.dart';
import 'package:rider_pay_user/view/home/domain/repo/profile_repo.dart';

class ProfileRepoImp implements ProfileRepo {
  final BaseApiServices api;

  ProfileRepoImp(this.api);

  @override
  Future<GetProfileModel> getProfile(String userid) async {
    try {
      final res = await api.getGetApiResponse(ApiUrls.getProfile+userid);
      return GetProfileModel.fromJson(res);
    } catch (e) {
      throw Exception("Failed to load getProfile: $e");
    }
  }

  @override
  Future<dynamic> updateProfile(dynamic data ) async{
    try {
      final res = await api.getPostApiResponse(ApiUrls.updateProfile,data);
      return res;
    } catch (e) {
      throw Exception("Failed to load updateProfile: $e");
    }
  }

  @override
  Future <dynamic> deleteAccountApi(String userId) async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.deleteProfile+userId);
      return res;
    } catch (e) {
      throw Exception("Failed to load deleteAccountApi: $e");
    }
  }

  @override
  Future <GetVoucherModel> getVoucherApi(String userId) async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.getVoucherUrl+userId);
      return GetVoucherModel.fromJson(res);
    } catch (e) {
      throw Exception("Failed to load getVoucherApi: $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getCmsPages() async {
    try {
      final res = await api.getGetApiResponse(ApiUrls.getCmsUrl);
      return res;
    } catch (e) {
      throw Exception("Failed to load getCmsPages: $e");
    }
  }
}
