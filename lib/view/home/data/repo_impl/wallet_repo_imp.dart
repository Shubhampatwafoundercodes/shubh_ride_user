
import 'package:rider_pay_user/helper/network/base_api_service.dart';
import 'package:rider_pay_user/res/api_urls.dart';
import 'package:rider_pay_user/view/home/data/model/wallet_data_model.dart';
import 'package:rider_pay_user/view/home/domain/repo/wallet_repo.dart';

class WalletRepoImp implements WalletRepo {
  final BaseApiServices api;

  WalletRepoImp(this.api);


  @override
  Future<GetWalletHistoryModel> getWalletHistoryApi(String userId) async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.getWalletHistory+userId);
      print("ASGHHHHHHHHHHH $res");
      return GetWalletHistoryModel.fromJson(res);
    } catch (e) {
      throw Exception("Failed to load getWalletHistoryApi $e");
    }  }
}
