import 'package:rider_pay_user/helper/network/base_api_service.dart';
import 'package:rider_pay_user/res/api_urls.dart';
import 'package:rider_pay_user/view/map/domain/repositories/check_zone_repo.dart';

class CheckZoneImpl implements CheckZoneRepo {
  final BaseApiServices api;

  CheckZoneImpl(this.api);



  @override
  Future <dynamic> checkZoneApi(dynamic data) async{
    try {
      final res = await api.getPostApiResponse(ApiUrls.checkZoneUrl,data);
      return res;
    } catch (e) {
      throw Exception("Failed to load checkZoneApi $e");
    }
  }
  }
