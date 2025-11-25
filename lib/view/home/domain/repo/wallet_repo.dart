import 'package:rider_pay_user/view/home/data/model/wallet_data_model.dart';

abstract class WalletRepo{

  Future<GetWalletHistoryModel> getWalletHistoryApi(String userId);


}