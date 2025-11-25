import 'package:rider_pay_user/view/home/data/model/notification_model.dart';

abstract class NotificationRepo{

  Future<NotificationModel> notificationApi(String userId,String type);


}