import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginEmail extends StatefulWidget {
  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  final forgotPassword = FlatButton(
    onPressed: () {
      //forgot password screen
    },
    textColor: Colors.white,
    child: Text('Forgot Password'),
  );

  Future<void> _saveData({userEmail: '',password: '',loggedIn: ''}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userEmail", userEmail);
    prefs.setString("loggedIn", loggedIn);
    prefs.setString("password", password);
  }

  void _showAlertDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
              'Invalid Email or password',
              style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Retry'))
            ],
          );
        });
  }

  Future<void> signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).pushNamed('/loading');
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        Navigator.of(context).pop();
        if (user != null) {
          _saveData(userEmail: _email, password: _password, loggedIn: "yes");
          Navigator.of(context).pushNamed('/navigation', arguments: user.email);
        }
      } catch (e) {
        print(e.message);
        Navigator.of(context).pop();
        _showAlertDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 144, 28, 238),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            height: 350,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01)),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01),
                          child: TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please enter the email';
                              }
                            },
                            onSaved: (input) => _email = input,
                            obscureText: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 10)),
                              hintText: "xyz@gmail.com",
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01),
                          child: TextFormField(
                            validator: (input) {
                              if (input.length < 6) {
                                return 'Passwords should be of atleat 6 characters';
                              }
                            },
                            onSaved: (input) => _password = input,
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 10)),
                              hintText: "Password",
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: signIn,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                forgotPassword,
                Center(
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(right: 10, left: 20)),
                      Text("Don't have an account?",
                          style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10),
                      FlatButton(
                        padding: EdgeInsets.all(10),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/signUp_email');
                        },
                        color: Color.fromARGB(255, 255, 255, 255),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            color: Color.fromARGB(255, 144, 28, 238),
          ),
        ),
      ),
    );
  }
}
