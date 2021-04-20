import 'dart:convert';

class Shop {
  String shopID;
  String address;
  String ownerId;
  String contact;
  String shopName;
  String location;
  String type;

  Shop({
    this.shopID,
    this.address,
    this.ownerId,
    this.contact,
    this.shopName,
    this.location,
    this.type,
  });

  factory Shop.fromMap(Map<String, dynamic> json) => new Shop(
        shopID: json["shopID"],
        address: json["address"],
        ownerId: json["ownerId"],
        contact: json["contact"],
        shopName: json["shopName"],
        location: json["location"],
        type: json["type"],
      );

  Map<String, String> toMap() => {
        "shopID": shopID,
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
