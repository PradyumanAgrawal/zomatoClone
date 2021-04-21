import 'dart:async';

import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/productModel.dart';

class ProductBloc {
  String shopId;
  String category;
  ProductBloc({this.shopId, this.category}) {
    getProducts();
    if (shopId != null) getShopProducts(shopId);
    if (category != null) getCategoryProducts(category);
  }
  final _productController = StreamController<List<Product>>.broadcast();
  final _shopProductController = StreamController<List<Product>>.broadcast();
  final _categoryProductController =
      StreamController<List<Product>>.broadcast();

  get products => _productController.stream;
  get shopProducts => _shopProductController.stream;
  get categoryProducts => _categoryProductController.stream;

  getProducts() async {
    _productController.sink.add(await DBProvider.db.getProducts());
  }

  getShopProducts(String shopId) async {
    _shopProductController.sink
        .add(await DBProvider.db.getShopProducts(shopId));
  }

  getCategoryProducts(String category) async {
    _categoryProductController.sink
        .add(await DBProvider.db.getCategoryProducts(category));
  }

  dispose() {
    _productController.close();
    _shopProductController.close();
    _categoryProductController.close();
  }
}
