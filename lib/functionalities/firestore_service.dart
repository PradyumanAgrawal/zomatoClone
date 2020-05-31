import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';

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

  Stream getProducts() {
    Stream<QuerySnapshot> prods=db.collection('products').snapshots();
    return prods;
  }
  Stream getCollection() {
    return db.collection('products').snapshots();
  }

  searchByName(String searchField) {
    return db
        .collection('products')
        .where('searchIndex',
            isEqualTo: searchField.substring(0,1).toUpperCase())
        .getDocuments();
  }

  Stream getCategories() {
    return db.collection('categories').snapshots();
  }

  Future<bool> inWishlist(String productId)
  {
    LocalData().getUid().then((uId){
      db.collection('users').document(uId).get().then((DocumentSnapshot userDoc){
        
      });
    });
  }

  void addToWishlist(String productId)
  {
    String userId;
    LocalData().getUserEmail().then((userEmail){
      db.collection('users').where('email',isEqualTo: userEmail).getDocuments().then((QuerySnapshot userDoc){
        if(userDoc.documents.isNotEmpty){
          userId = userDoc.documents[0].documentID;
          List wishlist = userDoc.documents[0]['wishlist'];
          if(wishlist.contains(productId))
            wishlist.remove(productId);
          else
            wishlist.add(productId);
          db.collection('users').document(userId).updateData({'wishlist': wishlist});
        }
      });
    });
  }

  Stream getProductsFromCategory(String category)
  {
    return db.collection('products').where('category', isEqualTo : category).snapshots();
  }

  Stream getWishlistProducts(List wishlist)
  {
    return db.collection('products').where('productId', whereIn: wishlist).snapshots();
  }

  Stream getUser(String userId){
    return db.collection('users').document(userId).snapshots();
  }

  Future<int> addToCart(String productId, int quantity, bool updating) async {
    Future<String> email = LocalData().getUserEmail().then((userEmail) {
      db.collection('users').where('email', isEqualTo: userEmail).getDocuments().then((QuerySnapshot document) {
        if (document.documents.isNotEmpty) {
          String userId = document.documents[0].documentID;
          Map cart = document.documents[0]['cart'];
          if (updating) {
            if (quantity == 0)
              cart.remove(productId);
            else
              cart['$productId'] =
                  quantity; // updating the quantity of the product in the cart
            //cart.addEntries({'$productId' : quantity})
            db.collection('users').document(userId).updateData({'cart': cart});
            return 3; // cart updated
          } else {
            if (cart.containsKey(productId))
              return 1; //product is already in the cart
            else {
              cart['$productId'] = quantity; // adding a new entry in the map
              db
                  .collection('users')
                  .document(userId)
                  .updateData({'cart': cart});
              return 2; //added a new product in the cart
            }
          }
        }
      }).catchError((error) {
        print('error: ' + error);
        return false;
      });
    });
  }
}
