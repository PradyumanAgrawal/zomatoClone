import 'dart:convert';

class Shop {
  int shopId;
  String address;
  int ownerId;
  String contact;
  String shopName;
  String location;
  String type;

  Shop({
    this.shopId,
    this.address,
    this.ownerId,
    this.contact,
    this.shopName,
    this.location,
    this.type,
  });

  factory Shop.fromMap(Map<String, dynamic> json) => new Shop(
        shopId: json["shopId"],
        address: json["address"],
        ownerId: json["ownerId"],
        contact: json["contact"],
        shopName: json["shopName"],
        location: json["location"],
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "shopId": shopId,
        "address": address,
        "ownerId": ownerId,
        "contact": contact,
        "shopName": shopName,
        "location": location,
        "type": type,
      };
}

Shop productFromJson(String str) {
  final jsonData = json.decode(str);
  return Shop.fromMap(jsonData);
}

String productToJson(Shop data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
