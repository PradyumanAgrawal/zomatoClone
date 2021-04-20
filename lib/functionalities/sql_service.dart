import 'dart:convert';
import 'dart:io';
import 'package:my_flutter_app/functionalities/populateDatabase.dart';
import 'package:my_flutter_app/models/addressModel.dart';
import 'package:my_flutter_app/models/orderModel.dart';
import 'package:my_flutter_app/models/productModel.dart';
import 'package:my_flutter_app/models/shopModel.dart';
import 'package:my_flutter_app/models/userModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        final populator = PopulateDatabase(db: db);
        populator.populateDB();
      },
    );
  }

  getUser(String userId) async {
    Response response = await get('http://10.0.2.2:3000/user/1');
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    User user = User.fromMap(jsonData[0]);
    return user;
    //final db = await database;
    //var res = await db.query("users", where: "id = ?", whereArgs: [userId]);
    //return res.isNotEmpty ? User.fromMap(res.first) : null;
  }

  getAddress(String userId) async {
    final db = await database;
    List<Map<String, Object>> res =
        await db.query("address", where: "userId = ?", whereArgs: [userId]);
    List<Address> addresses;
    res.forEach((add) => {addresses.add(Address.fromMap(add))});
    return addresses.isNotEmpty ? addresses : null;
  }

  deleteAddress(String userId) async {
    final db = await database;
    int res =
        await db.delete("address", where: "addrId = ?", whereArgs: [userId]);
    return res;
  }

  insertAddress(Address address) async {
    final db = await database;
    int res = await db.insert("address", address.toMap());
    return res;
  }

  getShops() async {
    Response response = await get('http://10.0.2.2:3000/shops');
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    // final db = await database;
    // List<Map<String, Object>> res = await db.query("shops");
    List<Shop> shops;
    jsonData.forEach((shop) => {shops.add(Shop.fromMap(shop))});
    return shops.isNotEmpty ? shops : null;
  }

  getCategories() async {
    final db = await database;
    List<Map<String, Object>> res = await db.query("categories");
    return res.isNotEmpty ? res : null;
  }

  getOrders(String userId) async {
    final db = await database;
    List<Map<String, Object>> res =
        await db.query("orders", where: "userId = ?", whereArgs: [userId]);
    List<Order> orders;
    res.forEach((order) => {orders.add(Order.fromMap(order))});
  }

  getProducts() async {
    final db = await database;
    List<Map<String, Object>> res = await db.query("products");
    List<Product> products;
    res.forEach((prod) => {products.add(Product.fromMap(prod))});
    return products.isNotEmpty ? products : null;
  }

  getSingleProd(String productId) async {
    final db = await database;
    List<Map<String, Object>> res = await db
        .query("products", where: "productId = ?", whereArgs: [productId]);
    Product product = Product.fromMap(res[0]);
    return product;
  }
}
