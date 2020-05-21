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
    return db.collection('products').snapshots();
  }
  Stream getCollection() {
    return db.collection('products').snapshots();
  }

  Stream getCategories() {
    return db.collection('categories').snapshots();
  }
  
  void changeFav(String docId, bool isFav) {
    db.collection('products').document(docId).updateData({'isFav': !isFav});
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
