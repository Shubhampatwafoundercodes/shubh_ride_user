import 'package:rider_pay_user/helper/network/base_api_service.dart';
import 'package:rider_pay_user/res/api_urls.dart';
import 'package:rider_pay_user/view/home/data/model/notification_model.dart';
import 'package:rider_pay_user/view/home/domain/repo/notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo {
  final BaseApiServices api;

  NotificationRepoImpl(this.api);



  @override
  Future<NotificationModel> notificationApi(String userId, String type) async{
    try {
      final url ="${ApiUrls.notificationUrl}$userId&userType=$type";
      final res = await api.getGetApiResponse(url);
      return NotificationModel.fromJson(res);
    } catch (e) {
      throw Exception("Failed to notificationApi $e");
    }
  }
}