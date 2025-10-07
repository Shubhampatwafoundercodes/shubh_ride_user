import 'package:rider_pay/view/home/data/model/address_type_model.dart';

abstract class AddressTypeRepo {
  Future<AddressTypeModel> addressTypeApi();
}