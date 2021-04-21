import 'dart:async';

import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/productModel.dart';

class ProductBloc {
  String shopId;
  ProductBloc({this.shopId}) {
    getProducts();
    if (shopId != null) getShopProducts(shopId);
  }
  final _productController = StreamController<List<Product>>.broadcast();
  final _shopProductController = StreamController<List<Product>>.broadcast();

  get products => _productController.stream;
  get shopProducts => _shopProductController.stream;

  getProducts() async {
    _productController.sink.add(await DBProvider.db.getProducts());
  }

  getShopProducts(String shopId) async {
    _shopProductController.sink
        .add(await DBProvider.db.getShopProducts(shopId));
  }

  dispose() {
    _productController.close();
    _shopProductController.close();
  }
}
