// ignore: file_names
import 'package:rider_pay_user/view/home/data/model/app_info_model.dart';

abstract class AppInfoRepo {
  Future<AppInfoModel> fetchAppInfo();
}