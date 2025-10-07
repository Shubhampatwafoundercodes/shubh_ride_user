import 'package:rider_pay/view/home/data/model/app_info_model.dart';

abstract class AppInfoRepo {
  Future<AppInfoModel> fetchAppInfo();
}