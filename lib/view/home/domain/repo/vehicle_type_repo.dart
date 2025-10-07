import 'package:rider_pay/view/home/data/model/vehicle_type_model.dart';

abstract class VehicleTypeRepo{
  Future<VehicleTypeModel> vehicleTypeApi();

}