import 'dart:convert';
import 'dart:io';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:my_flutter_app/functionalities/populateDatabase.dart';
import 'package:my_flutter_app/models/addressModel.dart';
import 'package:my_flutter_app/models/cartItem.dart';
import 'package:my_flutter_app/models/orderItem.dart';
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

  //Get one specific user details
  Future<User> getUser(String userId) async {
    Response response = await get('http://10.0.2.2:3000/user/' + userId);
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    User user = User.fromMap(jsonData[0]);
    return user;
  }

  Future<void> updateUserPhone(String userId, String phoneNo) async {
    Response response = await put('http://10.0.2.2:3000/user/' + userId,
        body: {"phone": phoneNo});
    String body = response.body;
    final jsonData = json.decode(body);
    //assert(jsonData is List);
  }

  Future<int> updateUserProfile(
      String userId, String name, String phoneNo) async {
    Response response = await put('http://10.0.2.2:3000/user/' + userId,
        body: {"phone": phoneNo, "name": name});
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is Map);
    return jsonData['status'];
  }

  // Get all address of one user
  Future<List<Address>> getAddress(String userId) async {
    Response response =
        await get('http://10.0.2.2:3000/user/address/' + userId);
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    List<Address> addresses = [];
    jsonData.forEach((add) => {addresses.add(Address.fromMap(add))});
    return addresses;
  }

  //delete An address with a specific addrId
  deleteAddress(int addrId) async {
    Response response =
        await delete('http://10.0.2.2:3000/address/' + addrId.toString());
    String body = response.body;
  }

  //Insert new addess into addrress table.
  insertAddress(Map<String, dynamic> address) async {
    Response response =
        await post('http://10.0.2.2:3000/address', body: address);
    String body = response.body;
  }

  //Get all shops details
  Future<List<Shop>> getShops() async {
    Response response = await get('http://10.0.2.2:3000/shops');
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    List<Shop> shops = [];
    for (int i = 0; i < jsonData.length; i++) {
      Shop temp = Shop.fromMap(jsonData[i]);
      shops.add(temp);
    }
    return shops.isNotEmpty ? shops : null;
  }

  getSingleShop(String shopId) async {
    Response response = await get('http://10.0.2.2:3000/shops/' + shopId);
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    Shop shop = Shop.fromMap(jsonData[0]);
    return shop;
  }

  //get all categories types
  getCategories() async {
    Response response = await get('http://10.0.2.2:3000/categories');
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    List<String> categories = [];
    jsonData.forEach((category) => {
          categories.add(
            category['category'],
          )
        });
    return categories;
  }

  //get all orders for one specific user
  Future<List<OrderItem>> getOrders(String userId) async {
    Response response = await get('http://10.0.2.2:3000/orders/' + userId);
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    List<OrderItem> orderItems = [];
    jsonData.forEach((item) => {orderItems.add(OrderItem.fromMap(item))});
    return orderItems;
  }

  //Get all products
  getProducts() async {
    Response response = await get('http://10.0.2.2:3000/products');
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    List<Product> products = [];
    jsonData.forEach((prod) => {products.add(Product.fromMap(prod))});
    return products;
  }

  getCustomSortProducts(String stream, String order, String meta) async {
    String path = 'http://10.0.2.2:3000/sort/' +
        stream +
        '?order=' +
        order +
        '&meta=' +
        meta;
    Response response = await get(path);
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    List<Product> products = [];
    jsonData.forEach((prod) => {products.add(Product.fromMap(prod))});
    return products;
  }

  getShopProducts(String shopId) async {
    Response response =
        await get('http://10.0.2.2:3000/shops/' + shopId + '/products');
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    List<Product> products = [];
    jsonData.forEach((prod) => {products.add(Product.fromMap(prod))});
    return products;
  }
  getSearchProducts(String searchSubstring) async {
    Response response =
        await get('http://10.0.2.2:3000/search/product/' + searchSubstring);
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    List<Product> products = [];
    jsonData.forEach((prod) => {products.add(Product.fromMap(prod))});
    return products;
  }
  getCategoryProducts(String category) async {
    Response response =
        await get('http://10.0.2.2:3000/products/type/' + category);
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    List<Product> products = [];
    jsonData.forEach((prod) => {products.add(Product.fromMap(prod))});
    return products;
  }

  //Get all products for discount section
  getOfferProducts() async {
    Response response =
        await get('http://10.0.2.2:3000/products?sort=discount&order=desc');
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    List<Product> products = [];
    jsonData.forEach((prod) => {products.add(Product.fromMap(prod))});
    return products;
  }

  //get a single product based on productId
  Future<Product> getSingleProd(String productId) async {
    Response response = await get('http://10.0.2.2:3000/products/' + productId);
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    Product prod = Product.fromMap(jsonData[0]);
    return prod;
  }

  Future<void> registerUser(
      String uid, String email, String displayName, String photoUrl) async {
    Response response = await post('http://10.0.2.2:3000/user', body: {
      "uid": uid,
      "email": email,
      "displayName": displayName,
      "photoUrl": photoUrl
    });
    String body = response.body;
    final jsonData = json.decode(body);
  }

  Future<List<CartItem>> getCartItems(String userId) async {
    Response response = await get('http://10.0.2.2:3000/cart/' + userId);
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is List);
    List<CartItem> cartItems = [];
    jsonData.forEach((prod) => {cartItems.add(CartItem.fromMap(prod))});
    return cartItems;
  }

  Future<int> updateCart(String userId, int productId, int quantity) async {
    Response response = await post('http://10.0.2.2:3000/cart', body: {
      'userId': userId,
      'productId': productId.toString(),
      'quantity': quantity.toString(),
    });
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is Map);
    return jsonData['status'];
  }

  Future<dynamic> reviewCart() async {
    double total = 0;
    int quant = 0;
    List<Map> products = [];
    String uid = await LocalData().getUid();
    List<CartItem> cartItems = await getCartItems(uid);
    if (cartItems.length == 0) {
      return 'empty';
    }
    for (int i = 0; i < cartItems.length; i++) {
      Map temp = new Map();
      temp['name'] = cartItems[i].product.pName;
      temp['price'] = cartItems[i].product.price;
      temp['quantity'] = cartItems[i].quantity;
      temp['image'] = cartItems[i].product.image;
      temp['discount'] = cartItems[i].product.discount == null
          ? '0'
          : cartItems[i].product.discount.toString();
      products.add(temp);
      total += cartItems[i].product.price *
          (1 -
              (cartItems[i].product.discount == null
                      ? 0
                      : cartItems[i].product.discount) /
                  100) *
          cartItems[i].quantity;
      //print(quantity[i]);
      quant += cartItems[i].quantity;
    }
    var a = {
      'total': total,
      'itemCount': quant,
      'products': products,
      'userId': uid,
    };
    return a;
  }

  Future<int> placeOrder(String addrId) async {
    Response response = await post('http://10.0.2.2:3000/orders/' + addrId);
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is Map);
    return jsonData['status'];
  }

  Future<void> setRating(String userId, int productId, double rating) async {
    Response response = await post('http://10.0.2.2:3000/review', body:{
      'userId': userId,
      'productId': productId.toString(),
      'rating': rating.toString(),
    });
    String body = response.body;
    final jsonData = json.decode(body);
    assert(jsonData is Map);
    //return jsonData['status'];
  }
}
