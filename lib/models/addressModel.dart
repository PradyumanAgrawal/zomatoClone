import 'dart:convert';

class Address {
  String addrId;
  String userId;
  String city;
  String line1;
  String line2;
  String name;
  String phone;
  String state;

  Address({
    this.addrId,
    this.userId,
    this.city,
    this.line1,
    this.line2,
    this.name,
    this.phone,
    this.state,
  });

  factory Address.fromMap(Map<String, String> json) => new Address(
        addrId: json["addrId"],
        userId: json["userId"],
        city: json["city"],
        line1: json["line1"],
        line2: json["line2"],
        name: json["name"],
        phone: json["phone"],
        state: json["state"],
      );

  Map<String, String> toMap() => {
        "addrId": addrId,
        "userId": userId,
        "city": city,
        "line1": line1,
        "line2": line2,
        "name": name,
        "phone": phone,
        "state": state,
      };
}

Address productFromJson(String str) {
  final jsonData = json.decode(str);
  return Address.fromMap(jsonData);
}

String productToJson(Address data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
