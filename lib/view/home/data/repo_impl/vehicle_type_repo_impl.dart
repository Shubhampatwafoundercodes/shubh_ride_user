
import 'package:rider_pay_user/helper/network/api_exception.dart';
import 'package:rider_pay_user/helper/network/base_api_service.dart';
import 'package:rider_pay_user/res/api_urls.dart';
import 'package:rider_pay_user/view/home/data/model/vehicle_type_model.dart';

import 'package:rider_pay_user/view/home/domain/repo/vehicle_type_repo.dart';

class VehicleTypeRepoImpl implements VehicleTypeRepo {
  final BaseApiServices api;

  VehicleTypeRepoImpl(this.api);


  @override
  Future<VehicleTypeModel> vehicleTypeApi() async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.vehicleTypeUrl);
      return VehicleTypeModel.fromJson(res);
    } catch (e) {
      throw AppException("Failed to load vehicleTypeApi $e");
    }  }
}
