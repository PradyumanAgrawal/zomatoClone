import 'dart:async';

import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/productModel.dart';


class ProductBloc {
  ProductBloc() {
    getProducts();
  }
  final _productController = StreamController<List<Product>>.broadcast();

  get products => _productController.stream;

  getProducts() async {
    _productController.sink.add(await DBProvider.db.getProducts());
  }
  dispose() {
    _productController.close();
  }
}
