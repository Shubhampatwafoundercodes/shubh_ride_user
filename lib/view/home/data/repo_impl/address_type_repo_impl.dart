import 'package:rider_pay/helper/network/base_api_service.dart';
import 'package:rider_pay/res/api_urls.dart';
import 'package:rider_pay/view/home/data/model/address_type_model.dart';
import 'package:rider_pay/view/home/domain/repo/address_type_repo.dart';

class AddressTypeRepoImpl implements AddressTypeRepo {
  final BaseApiServices api;

  AddressTypeRepoImpl(this.api);

  @override
  Future<AddressTypeModel> addressTypeApi() async {
    try {
      final res = await api.getGetApiResponse(ApiUrls.addressType);
      return AddressTypeModel.fromJson(res);
    } catch (e) {
      throw Exception("Failed to addressTypeApi $e");
    }
  }
}