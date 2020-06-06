import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  Stream getStores() {
    return db.collection('shops').snapshots();
  }

  Stream<List<DocumentSnapshot>> getNearbyStores(LatLng location)
  {
    Geoflutterfire geo = Geoflutterfire(); 
    GeoFirePoint center = geo.point(latitude: location.latitude, longitude: location.longitude);
    var collectionRef = db.collection('shops');
    var geoRef = geo.collection(collectionRef: collectionRef).within(center: center, radius: 25, field: 'location',strictMode: false);
    return geoRef;
  }

  Stream getProducts() {
    Stream<QuerySnapshot> prods = db.collection('products').snapshots();
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

  Stream getProductsFromShop(pId){
    return db.collection('products').where('productId',whereIn: pId).snapshots();
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

  Future<void> placeOrder(String address, String mobileNo) async {
    var uid = await LocalData().getUid();
    db.collection('users').document(uid).get().then((DocumentSnapshot doc) {
      doc['cart'].forEach((k, v) {
        db.collection('products').document(k).get().then((value) async {
          DocumentReference docRef = await db.collection('orders').add({
            'deliveryAddress':address,
            'customerMobileNo':mobileNo,
            'userId': uid,
            'prodId': k,
            'prodName': value['name'],
            'shop': value['shop'],
            'quantity': v,
            'amount': int.parse(value['price']) * v,
            'status': "pending",
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
    return db.collection('orders').where('userId', isEqualTo: uid).snapshots();
  }

  Future<int> addToCart(String productId, int quantity, bool updating) async {
    int status;
    await LocalData().getUserEmail().then((userEmail) async {
      await db
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .getDocuments()
          .then((QuerySnapshot document) {
        if (document.documents.isNotEmpty) {
          String userId = document.documents[0].documentID;
          Map cart = document.documents[0]['cart'];
          if (updating) {
            if (quantity == 0)
              cart.remove(productId);
            else
              cart['$productId'] = quantity; // updating the quantity of the product in the cart
            db.collection('users').document(userId).updateData({'cart': cart});
            status = 3; // cart updated
          } else {
            if (cart.containsKey(productId))
              status =  1; //product is already in the cart
            else {
              cart['$productId'] = quantity; // adding a new entry in the map
              db
                  .collection('users')
                  .document(userId)
                  .updateData({'cart': cart});
              status =  2; //added a new product in the cart
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
    int total = 0;
    int quant = 0;
    String uid = await LocalData().getUid();
    var u = await db.collection('users').document(uid).get();
    var cart = u.data['cart'].keys.toList();
    print(cart);
    if (cart.length == 0) {
      return 'empty';
    }
    var quantity = u.data['cart'].values.toList();
    print(quantity[0]);
    var q = await db
        .collection('products')
        .where('productId', whereIn: cart)
        .getDocuments();
    var prodList = q.documents.toList();
    for (int i = 0; i < cart.length; i++) {
      total += int.parse(prodList[i].data['price'])*quantity[i];
      quant += quantity[i];
    }
    var a = {
      'total': total,
      'itemCount': quant,
      'mobileNo': u.data['mobileNo'],
      'address':u.data['address']
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

  Future<void> addMobile(String newNumber)async{
    var uid = await LocalData().getUid();
    await db.collection('users').document(uid).updateData({'mobileNo':newNumber});
  }
  
  Future<void> addAddress(Map newAdd)async{
    var uid = await LocalData().getUid();
    var userDoc = await db.collection('users').document(uid).get();
    List<dynamic> address = userDoc['address'];
    address.add(newAdd);
    await db.collection('users').document(uid).updateData({'address':address});
  }
}
