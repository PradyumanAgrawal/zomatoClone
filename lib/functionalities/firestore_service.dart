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

  void changeFav(String docId, bool isFav) {
    db.collection('products').document(docId).updateData({'isFav': !isFav});
  }

  bool addToCart(String productId, int quantity) {
    Future<String> email = LocalData().getUserEmail().then((userEmail)
    {
      db.collection('users').where('email', isEqualTo: userEmail).getDocuments().then((QuerySnapshot document) 
      {
        if (document.documents.isNotEmpty) {
          String userId = document.documents[0].documentID;
          Map cart = document.documents[0]['cart'];
          cart['$productId'] = quantity;
          //cart.addEntries({'$productId' : quantity})
          db.collection('users').document(userId).updateData({'cart': cart});
          return true;
        }
        else return false;
      });
    }).catchError((error){
      print('error: ' + error);
      return false;
    });
    return false;
  }
}
