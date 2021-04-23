import 'dart:convert';

import 'package:my_flutter_app/models/productModel.dart';

class OrderItem {
  Product product;
  int quantity;
  int addrId;
  String status;
  int bill;
  String date;

  OrderItem({
    this.product,
    this.quantity,
    this.addrId,
    this.status,
    this.bill,
    this.date,
  });

  factory OrderItem.fromMap(Map<String, dynamic> json) => new OrderItem(
        product: Product.fromMap(json),
        quantity: json["quantity"],
        addrId: json["addrId"],
        status: json["status"],
        bill: json["bill"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "product": product,
        "quantity": quantity,
      };
}

OrderItem productFromJson(String str) {
  final jsonData = json.decode(str);
  return OrderItem.fromMap(jsonData);
}

String productToJson(OrderItem data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
