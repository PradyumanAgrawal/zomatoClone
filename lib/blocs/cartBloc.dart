import 'dart:async';

import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/addressModel.dart';
import 'package:my_flutter_app/models/cartItem.dart';

class CartBloc {
  String userId;
  CartBloc({this.userId}) {
    getCartItems(userId);
  }

  final _cartController = StreamController<List<CartItem>>.broadcast();

  get cartItems => _cartController.stream;

  getCartItems(String userId) async {
    List<CartItem> temp = await DBProvider.db.getCartItems(userId);
    _cartController.sink.add(temp);
  }

  Future<void> updateCart(String userId, int productId, int quantity) async {
    await DBProvider.db.updateCart(userId, productId, quantity);
    await getCartItems(userId);
  }

  Future<void> insertAddress(Map<String, dynamic> address) async {
    await DBProvider.db.insertAddress(address);
    await getCartItems(userId);
  }

  dispose() {
    _cartController.close();
  }
}
