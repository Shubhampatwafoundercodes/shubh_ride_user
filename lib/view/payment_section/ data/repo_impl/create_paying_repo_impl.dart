

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/helper/network/base_api_service.dart';
import 'package:rider_pay_user/helper/network/network_api_service_http.dart';
import 'package:rider_pay_user/res/api_urls.dart';
import 'package:rider_pay_user/view/payment_section/domain/repo/create_paying_repo.dart';

class CreatePayingRepoImpl implements CreatePayingRepo{
  final BaseApiServices api;

  CreatePayingRepoImpl(this.api);


  @override
  Future <dynamic> createPayingSession(String userId,dynamic amount) async{
    try {
      Map data={
        "userId":userId,
        "amount":amount
      };
      final res = await api.getPostApiResponse(ApiUrls.createPaying,data);
      return  res;
    } catch (e) {
      throw Exception("Failed to load createPayingSession $e");
    }
  }

}


final createPayingRepoProvider = Provider<CreatePayingRepoImpl>((ref) {
  return CreatePayingRepoImpl(NetworkApiServices(ref));
});