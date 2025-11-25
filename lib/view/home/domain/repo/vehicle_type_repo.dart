import 'package:rider_pay_user/view/home/data/model/vehicle_type_model.dart';

abstract class VehicleTypeRepo{
  Future<VehicleTypeModel> vehicleTypeApi();

}