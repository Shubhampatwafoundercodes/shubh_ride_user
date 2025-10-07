import 'package:rider_pay/view/home/data/model/wallet_data_model.dart';

abstract class WalletRepo{

  Future<WalletDataModel> getWalletHistoryApi(String userId);


}