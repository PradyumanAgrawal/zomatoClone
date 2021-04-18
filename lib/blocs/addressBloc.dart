import 'dart:async';

import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/addressModel.dart';
import 'package:my_flutter_app/models/userModel.dart';

class AddressBloc {
  String userId;
  AddressBloc({this.userId}) {
    getCart(userId);
  }

  final _cartController = StreamController<List<Address>>.broadcast();

  get users => _cartController.stream;

  getCart(String userId) async {
    _cartController.sink.add(await DBProvider.db.getAddress(userId));
  }

  dispose() {
    _cartController.close();
  }
}
