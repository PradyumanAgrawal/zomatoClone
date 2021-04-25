import 'dart:async';

import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/productModel.dart';

class SingleProductBloc {
  String productId;
  SingleProductBloc({this.productId}) {
    getProduct();
  }
  final _productController = StreamController<Product>.broadcast();

  get product => _productController.stream;

  getProduct() async {
    _productController.sink.add(await DBProvider.db.getSingleProd(productId));
  }

  dispose() {
    _productController.close();
  }

  setRating(String userId, int productId, double rating) async {
    await DBProvider.db.setRating(userId, productId, rating);
    getProduct();
  }
}
