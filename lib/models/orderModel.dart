import 'dart:convert';

class Order {
  String addrId;
  String productId;
  String status;
  String date;
  String bill;

  Order({
    this.addrId,
    this.productId,
    this.status,
    this.date,
    this.bill,
  });

  factory Order.fromMap(Map<String, String> json) => new Order(
        addrId: json["addrId"],
        productId: json["productId"],
        status: json["status"],
        date: json["date"],
        bill: json["bill"],
      );

  Map<String, String> toMap() => {
        "addrId": addrId,
        "productId": productId,
        "status": status,
        "date": date,
        "bill": bill,
      };
}

Order productFromJson(String str) {
  final jsonData = json.decode(str);
  return Order.fromMap(jsonData);
}

String productToJson(Order data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
