import 'package:flutter/material.dart';
import 'package:my_flutter_app/functionalities/auth.dart';

class GoogleSignIn extends StatefulWidget {
  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  AuthService auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: auth.googleSignIn(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/navigation');
                    },
                    child: Text('Continue'));
              }
              else{
                return RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Error Signing in with google'));
              }
            } 
            else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),

      /* FutureBuilder(
          future: auth.googleSignIn(),
          builder: (context, snapshot){
            
          }), */
    );
  }
}
