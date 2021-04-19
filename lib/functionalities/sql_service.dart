import 'dart:io';
import 'package:my_flutter_app/models/addressModel.dart';
import 'package:my_flutter_app/models/productModel.dart';
import 'package:my_flutter_app/models/shopModel.dart';
import 'package:my_flutter_app/models/userModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
        await db.execute("CREATE TABLE Client ("
            "id INTEGER PRIMARY KEY,"
            "first_name TEXT,"
            "last_name TEXT,"
            "blocked BIT"
            ")");
      },
    );
  }

  getUser(String userId) async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [userId]);
    return res.isNotEmpty ? User.fromMap(res.first) : null;
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
    final db = await database;
    List<Map<String, Object>> res = await db.query("shops");
    List<Shop> shops;
    res.forEach((shop) => {shops.add(Shop.fromMap(shop))});
    return shops.isNotEmpty ? shops : null;
  }

  getProducts() async {
    final db = await database;
    List<Map<String, Object>> res = await db.query("products");
    List<Product> products;
    res.forEach((prod) => {products.add(Product.fromMap(prod))});
    return products.isNotEmpty ? products : null;
  }
}
