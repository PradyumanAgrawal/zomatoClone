import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_flutter_app/ui/myApp.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  LocalData localData = new LocalData();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  String _token;
  String _userId;
  //final Firestore _db = Firestore.instance;

  Future<bool> signInWithEmail({email: '', password: ''}) async {
    try {
      FirebaseUser user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        String token = await _messaging.getToken();
        _token = token;
        _userId = user.uid;
        localData.saveData(
            userEmail: email,
            password: password,
            loggedIn: "yes",
            uid: user.uid,
            token: token);
        FirestoreService().saveToken(token, user.uid);
        return true;
      }
      return false;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> signUpWithEmail({email: '', password: ''}) async {
    try {
      FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      //updateUserData(user);
      if (user != null) {
        String token = await _messaging.getToken();
        _token = token;
        _userId = user.uid;
        localData.saveData(
            userEmail: email,
            password: password,
            loggedIn: "yes",
            uid: user.uid,
            token: token);
        FirestoreService().saveToken(token, user.uid);
        return true;
      }
      return false;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String userId = prefs.getString("uid");
    prefs.setString("loggedIn", "no");
    prefs.setString("userEmail", null);
    prefs.setString("password", null);
    prefs.setString('uid', null);
    prefs.setString("token", null);
    await FirestoreService().deleteToken(token, userId);

    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      String token = await _messaging.getToken();
      _token = token;
      _userId = user.uid;
      localData.saveData(
          userEmail: user.email,
          password: '',
          loggedIn: "yes",
          uid: user.uid,
          token: token);
      FirestoreService().saveToken(token, user.uid);
      print("user name: ${user.displayName}");
      print(user.displayName);
      print(user.photoUrl);
      //updateUserData(user);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  /* void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    ref.setData({
//      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  } */

}

//final AuthService authService = AuthService();
