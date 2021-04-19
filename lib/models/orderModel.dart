import 'dart:convert';

class Order {
  String addrId;
  String productId;
  String status;
  String date;
  String bill;
  String image;
  String quantity;

  Order({
    this.addrId,
    this.productId,
    this.status,
    this.date,
    this.bill,
    this.image,
    this.quantity,
  });

  factory Order.fromMap(Map<String, String> json) => new Order(
        addrId: json["addrId"],
        productId: json["productId"],
        status: json["status"],
        date: json["date"],
        bill: json["bill"],
        image: json["image"],
        quantity: json["quantity"],
      );

  Map<String, String> toMap() => {
        "addrId": addrId,
        "productId": productId,
        "status": status,
        "date": date,
        "bill": bill,
        "image": image,
        "quantity": quantity,
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
