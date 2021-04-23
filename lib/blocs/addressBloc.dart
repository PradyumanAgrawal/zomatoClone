import 'dart:async';

import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/addressModel.dart';

class AddressBloc {
  String userId;
  AddressBloc({this.userId}) {
    getAddress(userId);
  }

  final _addressController = StreamController<List<Address>>.broadcast();

  get addresses => _addressController.stream;

  getAddress(String userId) async {
    List<Address> temp = await DBProvider.db.getAddress(userId);
    _addressController.sink.add(temp);
  }
  reset() async
  {
    await getAddress(userId);
  }
  Future<void> deleteAddress(int addrId) async {
    await DBProvider.db.deleteAddress(addrId);
    await getAddress(userId);
  }

  Future<void> insertAddress(Map<String, dynamic> address) async {
    await DBProvider.db.insertAddress(address);
    await getAddress(userId);
  }

  dispose() {
    _addressController.close();
  }
}
