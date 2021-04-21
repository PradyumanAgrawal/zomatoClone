import 'dart:convert';

class Product {
  int productId;
  int shopId;
  String pName;
  String description;
  int price;
  String image;
  int discount;
  String category;

  Product({
    this.productId,
    this.shopId,
    this.pName,
    this.description,
    this.price,
    this.image,
    this.discount,
    this.category,
  });

  factory Product.fromMap(Map<String, dynamic> json) => new Product(
        productId: json["productId"],
        shopId: json["shopId"],
        pName: json["pName"],
        description: json["description"],
        price: json["price"],
        image: json["image"],
        discount: json["discount"],
        category: json["category"],
      );

  Map<String, dynamic> toMap() => {
        "productId": productId,
        "shopId": shopId,
        "pName": pName,
        "description": description,
        "price": price,
        "image": image,
        "discount": discount,
        "category": category,
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
