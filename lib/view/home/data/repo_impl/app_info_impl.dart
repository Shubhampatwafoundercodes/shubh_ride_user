import 'package:rider_pay_user/helper/network/base_api_service.dart';
import 'package:rider_pay_user/res/api_urls.dart';
import 'package:rider_pay_user/view/home/data/model/app_info_model.dart';
import 'package:rider_pay_user/view/home/domain/repo/app_Info_repo.dart';

class AppInfoImpl implements AppInfoRepo {
  final BaseApiServices api;

  AppInfoImpl(this.api);

  @override
  Future<AppInfoModel> fetchAppInfo() async {
    try {
      final res = await api.getGetApiResponse(ApiUrls.getAppInfo);
      return AppInfoModel.fromJson(res);
    } catch (e) {
      throw Exception("Failed to load app info: $e");
    }
  }
}
