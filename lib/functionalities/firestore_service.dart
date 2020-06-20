import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/functionalities/analytics.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FirestoreService {
  static final FirestoreService _firestoreService =
      FirestoreService._internal();
  Firestore db = Firestore.instance;


  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  Stream getAllStores() {
    return db.collection('shops').snapshots();
  }

  Stream<List<DocumentSnapshot>> getNearbyStores(LatLng location) {
    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint center =
        geo.point(latitude: location.latitude, longitude: location.longitude);
    var collectionRef = db.collection('shops');
    var geoRef = geo.collection(collectionRef: collectionRef).within(
        center: center, radius: 25, field: 'location', strictMode: false);
    return geoRef;
  }

  Future<void> saveToken(String token, String userId) async {
    DocumentSnapshot user = await db.collection('users').document(userId).get();
    List tokens = user['tokens'];
    if (!tokens.contains(token) && token!=null) {
      tokens.add(token);
      await user.reference.updateData({'tokens': tokens});
      print(token);
    }
  }

  Future<void> deleteToken(String token, String userId) async {
    DocumentSnapshot user = await db.collection('users').document(userId).get();
    List tokens = user['tokens'];
    tokens.remove(token);
    await user.reference.updateData({'tokens': tokens});
  }

  Stream getProducts() {
    Stream<QuerySnapshot> prods = db.collection('products').snapshots();
    return prods;
  }

  Stream getOfferPosters() {
    return db.collection('offers').document('posters').snapshots();
  }

  Stream getHomeProducts() {
    Stream<QuerySnapshot> prods =
        db.collection('products').where('onHome', isEqualTo: true).snapshots();
    return prods;
  }

  Stream getCartProducts(dynamic cart) {
    Stream<QuerySnapshot> prods =
        db.collection('products').where('productId', whereIn: cart).snapshots();
    return prods;
  }

  Stream getCollection() {
    return db.collection('products').snapshots();
  }

  searchByName(String searchField) {
    return db
        .collection('products')
        .where('searchIndex',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }

  Stream getCategories() {
    return db.collection('categories').snapshots();
  }

  Future<bool> inWishlist(String productId) {
    LocalData().getUid().then((uId) {
      db
          .collection('users')
          .document(uId)
          .get()
          .then((DocumentSnapshot userDoc) {});
    });
  }

  void addToWishlist(String productId) {
    String userId;
    LocalData().getUserEmail().then((userEmail) {
      db
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .getDocuments()
          .then((QuerySnapshot userDoc) {
        if (userDoc.documents.isNotEmpty) {
          userId = userDoc.documents[0].documentID;
          List wishlist = userDoc.documents[0]['wishlist'];
          if (wishlist.contains(productId))
            wishlist.remove(productId);
          else
            wishlist.add(productId);
          db
              .collection('users')
              .document(userId)
              .updateData({'wishlist': wishlist});
        }
      });
    });
  }

  Stream getProductsFromCategory(String category) {
    return db
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots();
  }

  Stream getShopProducts(String shopID) {
    return db
        .collection('products')
        .where('shop', isEqualTo: db.collection('shops').document(shopID))
        .snapshots();
  }

  Stream getOfferProducts() {
    return db
        .collection('products')
        .orderBy('discount', descending: true)
        .snapshots();
  }

  Stream getWishlistProducts(List wishlist) {
    return db
        .collection('products')
        .where('productId', whereIn: wishlist)
        .snapshots();
  }

  Stream getUser(String userId) {
    return db.collection('users').document(userId).snapshots();
  }

  Future<void> placeOrder(Map address, String mobileNo,String paymentMethod, String txnID) async {
    var uid = await LocalData().getUid();
    db.collection('users').document(uid).get().then((DocumentSnapshot doc) {
      doc['cart'].forEach((k, v) {
        db.collection('products').document(k).get().then((value) async {
          DocumentReference docRef = await db.collection('orders').add({
            'deliveryAddress': address,
            'customerMobileNo': mobileNo,
            'userId': uid,
            'prodId': k,
            'prodName': value['name'],
            'shop': value['shop'],
            'quantity': v['quantity'],
            'discount': value['discount'],
            'paymentMethod':paymentMethod,
            'amount': int.parse(value['price']) *
                (1 - int.parse(value['discount']) / 100) *
                v['quantity'],
            'amountWithCharge': int.parse(value['price']) *
                (1 - int.parse(value['discount']) / 100) *
                v['quantity']*1.0236,
            'variant': v['variant'],
            'status': "pending",
            'timeStamp': FieldValue.serverTimestamp(),
            'image': value['catalogue'][0],
            'txnID': txnID,
          });
          List orders = doc['orderHistory'];
          orders.add(docRef.documentID);
          doc.reference.updateData({'orderHistory': orders});
        });
      });
    }).then((value) {
      db.collection('users').document(uid).updateData({'cart': {}});
    });
  }

  Stream getOrders(String uid) {
    return db
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Future<int> addToCart(
      String productId, int quantity, String variant, bool updating, DocumentSnapshot prodDocument) async {
    int status;
    await LocalData().getUserEmail().then((userEmail) async {
      await db
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .getDocuments()
          .then((QuerySnapshot document) async {
        if (document.documents.isNotEmpty) {
          String userId = document.documents[0].documentID;
          Map cart = document.documents[0]['cart'];
          if (updating) {
            if (quantity == 0)
              cart.remove(productId);
            else
              cart['$productId'] = {
                'quantity': quantity,
                'variant': variant
              }; // updating the quantity of the product in the cart
            db.collection('users').document(userId).updateData({'cart': cart});
            status = 3; // cart updated
          } else {
            if (cart.containsKey(productId))
              status = 1; //product is already in the cart
            else {
              cart['$productId'] = {
                'quantity': quantity,
                'variant': variant
              }; // adding a new entry in the map
              db
                  .collection('users')
                  .document(userId)
                  .updateData({'cart': cart});
              await AnalyticsService().logAddToCart(productId, prodDocument['name'],prodDocument['category'],'1');
              status = 2; //added a new product in the cart
            }
          }
        }
      }).catchError((error) {
        print('error: ' + error);
        status = 0;
      });
    });

    return status;
  }

  Future<DocumentSnapshot> getShop(DocumentReference shopRef) async {
    // shopRef.get().then((documentSnapshot){
    //   return documentSnapshot;
    // });
    return await shopRef.get();
  }

  Future<bool> isProfileComplete(String userId) async {
    DocumentSnapshot userDoc =
        await db.collection('users').document(userId).get();
    return userDoc['isProfileComplete'];
  }

  Future<bool> editProfile(String name, String email, String phone,
      DocumentSnapshot userDoc, File profilePic) async {
    if (profilePic != null) {
      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile/' + userDoc.documentID);
      final StorageUploadTask task = firebaseStorageRef.putFile(profilePic);
      await task.onComplete;
      print('files uploaded');
      await firebaseStorageRef.getDownloadURL().then((url) {
        print(url);
        userDoc.reference.updateData({'displayPic': url});
      });
    }
    bool status;
    bool isProfileComplete = phone != null &&
        phone != '' &&
        email != null &&
        email != '' &&
        userDoc['address'] != [];
    await userDoc.reference.updateData({
      'name': name,
      'mobileNo': phone,
      'isProfileComplete': isProfileComplete
    }).then((value) {
      status = true;
    });
    return status;
  }

  Future<dynamic> reviewCart() async {
    double total = 0;
    int quant = 0;
    List<Map> products = [];
    String uid = await LocalData().getUid();
    var user = await db.collection('users').document(uid).get();
    var cart = user.data['cart'].keys.toList();
    print(cart);
    if (cart.length == 0) {
      return 'empty';
    }
    //var quantity = user.data['cart'].values.toList();
    //print(quantity[0]);
    var q = await db
        .collection('products')
        .where('productId', whereIn: cart)
        .getDocuments();
    var prodList = q.documents.toList();
    for (int i = 0; i < cart.length; i++) {
      Map temp = new Map();
      temp['name'] = prodList[i]['name'];
      temp['price'] = prodList[i]['price'];
      temp['quantity'] = user.data['cart'][prodList[i].documentID]['quantity'];
      temp['image'] = prodList[i]['catalogue'][0];
      temp['discount'] =
          prodList[i]['discount'] == null ? '0' : prodList[i]['discount'];
      temp['variant'] = user.data['cart'][prodList[i].documentID]['variant'];
      products.add(temp);
      print(int.parse(prodList[i].data['price']));
      total += int.parse(prodList[i].data['price']) *
          (1 -
              int.parse(prodList[i].data['discount'] == null
                      ? '0'
                      : prodList[i].data['discount']) /
                  100) *
          user.data['cart'][prodList[i].documentID]['quantity'];
      //print(quantity[i]);
      quant += user.data['cart'][prodList[i].documentID]['quantity'];
    }
    var a = {
      'total': total,
      'itemCount': quant,
      'mobileNo': user.data['mobileNo'],
      'address': user.data['address'],
      'products': products,
      'userId': uid,
    };
    return a;
  }

  Future<bool> removeAddress(int index, DocumentSnapshot userDoc) {
    List address = userDoc['address'];
    address.removeAt(index);
    userDoc.reference.updateData({'address': address});
  }

  void newAddress(Map newAddress, DocumentSnapshot userDoc) {
    List address = userDoc['address'];
    address.add(newAddress);
    userDoc.reference.updateData({'address': address});
  }

  Future<void> addMobile(String newNumber) async {
    var uid = await LocalData().getUid();
    await db
        .collection('users')
        .document(uid)
        .updateData({'mobileNo': newNumber});
  }

  Future<void> addFeedback(String Feedback) async {
    var uid = await LocalData().getUid();
    await db
        .collection('feedback')
        .document()
        .setData({"Feedback": Feedback, "userId": uid});
  }

  Future<void> addAddress(Map newAdd) async {
    var uid = await LocalData().getUid();
    var userDoc = await db.collection('users').document(uid).get();
    List<dynamic> address = userDoc['address'];
    address.add(newAdd);
    await db.collection('users').document(uid).updateData({'address': address});
  }
}
