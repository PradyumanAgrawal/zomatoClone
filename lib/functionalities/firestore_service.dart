import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService _firestoreService = FirestoreService._internal();
  Firestore db = Firestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  Stream getStores(){
    return db.collection('shops').snapshots();
  }

  Stream getProducts(){
    return db.collection('products').snapshots();
  }

  void changeFav(String docId , bool isFav)
  {
    db.collection('products').document(docId).updateData({'isFav' : !isFav});
  }
}