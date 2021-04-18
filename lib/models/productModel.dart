import 'dart:convert';

class Product {
  String productId;
  String shopID;
  String pName;
  String description;
  String price;
  String image;

  Product(
      {this.productId,
      this.shopID,
      this.pName,
      this.description,
      this.price,
      this.image});

  factory Product.fromMap(Map<String, String> json) => new Product(
      productId: json["productId"],
      shopID: json["shopID"],
      pName: json["pName"],
      description: json["description"],
      price: json["price"],
      image: json["image"]);

  Map<String, String> toMap() => {
        "productId": productId,
        "shopID": shopID,
        "pName": pName,
        "description": description,
        "price": price,
        "image": image
      };
}

Product productFromJson(String str) {
  final jsonData = json.decode(str);
  return Product.fromMap(jsonData);
}

String productToJson(Product data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
