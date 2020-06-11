import 'package:flutter/material.dart';
import 'package:my_flutter_app/functionalities/auth.dart';

class LoginEmail extends StatefulWidget {
  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  AuthService auth = new AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

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
      bool value =
          await auth.signInWithEmail(email: _email, password: _password);
      if (value == true) {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/navigation', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pop();
        _showAlertDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.deepPurple,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.pink, Colors.deepPurple])),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            //height: 350,
            width: double.infinity,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.1)),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Text(
                                "Login with Email",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height *
                                      0.01),
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
                                  hintText: "xyz@email.com",
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height *
                                      0.01),
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
                          height: 40,
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.white,
                            onPressed: signIn,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/forgot_password');
                      },
                      textColor: Colors.white,
                      child: Text('Forgot Password?'),
                    ),
                    Center(
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(right: 10, left: 20)),
                          Text("Don't have an account?",
                              style: TextStyle(color: Colors.white)),
                          SizedBox(width: 10),
                          Flexible(
                            child: ActionChip(
                              padding: EdgeInsets.all(10),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/signUp_email');
                              },
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                              label: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
