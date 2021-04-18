import 'dart:convert';

class User {
  String userId;
  String name;
  String mobileNo;
  String email;
  String location;
  String displayPic;

  User(
      {this.userId,
      this.name,
      this.mobileNo,
      this.email,
      this.location,
      this.displayPic});

  factory User.fromMap(Map<String, String> json) => new User(
        userId: json["userId"],
        name: json["name"],
        mobileNo: json["mobileNo"],
        email: json["email"],
        location: json["location"],
        displayPic: json["displayPic"],
      );

  Map<String, String> toMap() => {
        "userId": userId,
        "name": name,
        "mobileNo": mobileNo,
        "email": email,
        "location": location,
        "displayPic": displayPic,
      };
}

User productFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String productToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
