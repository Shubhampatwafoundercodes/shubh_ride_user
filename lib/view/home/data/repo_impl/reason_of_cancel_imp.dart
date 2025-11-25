
import 'package:rider_pay_user/helper/network/api_exception.dart';
import 'package:rider_pay_user/helper/network/base_api_service.dart';
import 'package:rider_pay_user/res/api_urls.dart';
import 'package:rider_pay_user/view/home/data/model/reson_of_cancel_model.dart';
import 'package:rider_pay_user/view/home/domain/repo/reason_of_cancel_repo.dart';

class ReasonOfCancelImp implements ReasonOfCancelRepo {
  final BaseApiServices api;

  ReasonOfCancelImp(this.api);

  @override
  Future<ReasonOfCancelModel> reasonOfCancelApi() async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.reasonOfCancel);
      return ReasonOfCancelModel.fromJson(res);
    } catch (e) {
      throw AppException("Failed to load getWalletHistoryApi $e");
    }
  }
}
