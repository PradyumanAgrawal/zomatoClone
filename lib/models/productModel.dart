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
  double rating;
  int numRating;

  Product({
    this.productId,
    this.shopId,
    this.pName,
    this.description,
    this.price,
    this.image,
    this.discount,
    this.category,
    this.rating,
    this.numRating,
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
        rating: json["rating"] * 1.0,
        numRating: json["numRating"],
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
        "rating": rating,
        "numRating": numRating,
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
