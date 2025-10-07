
import 'package:rider_pay/helper/network/base_api_service.dart';
import 'package:rider_pay/res/api_urls.dart';
import 'package:rider_pay/view/home/data/model/app_info_model.dart';
import 'package:rider_pay/view/home/data/model/wallet_data_model.dart';
import 'package:rider_pay/view/home/domain/repo/app_Info_repo.dart';
import 'package:rider_pay/view/home/domain/repo/wallet_repo.dart';

class WalletRepoImp implements WalletRepo {
  final BaseApiServices api;

  WalletRepoImp(this.api);


  @override
  Future<WalletDataModel> getWalletHistoryApi(String userId) async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.getAppInfo);
      return WalletDataModel.fromJson(res);
    } catch (e) {
      throw Exception("Failed to load getWalletHistoryApi $e");
    }  }
}
