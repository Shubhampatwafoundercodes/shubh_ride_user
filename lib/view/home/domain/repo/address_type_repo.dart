import 'package:rider_pay_user/view/home/data/model/address_type_model.dart';

abstract class AddressTypeRepo {
  Future<AddressTypeModel> addressTypeApi();
}