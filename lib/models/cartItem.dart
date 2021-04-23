import 'dart:convert';

import 'package:my_flutter_app/models/productModel.dart';

class CartItem {
  Product product;
  int quantity;

  CartItem({
    this.product,
    this.quantity,
  });

  factory CartItem.fromMap(Map<String, dynamic> json) => new CartItem(
        product: Product.fromMap(json),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toMap() => {
        "product": product,
        "quantity": quantity,
      };
}

CartItem productFromJson(String str) {
  final jsonData = json.decode(str);
  return CartItem.fromMap(jsonData);
}

String productToJson(CartItem data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
