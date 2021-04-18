import 'dart:async';

import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/shopModel.dart';

class ShopBloc {
  ShopBloc() {
    getShop();
  }

  final _shopsController = StreamController<List<Shop>>.broadcast();

  get shops => _shopsController.stream;

  getShop() async {
    _shopsController.sink.add(await DBProvider.db.getShops());
  }

  Future<void> deleteShop(String addrId) async {
    // await DBProvider.db.deleteShop(addrId);
    await getShop();
  }

  Future<void> insertShop(Shop address) async {
    // await DBProvider.db.insertShop(address);
    await getShop();
  }

  dispose() {
    _shopsController.close();
  }
}
