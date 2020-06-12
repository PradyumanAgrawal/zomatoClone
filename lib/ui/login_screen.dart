import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:my_flutter_app/functionalities/auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService auth = new AuthService();
  double bottonPadding = 10;
  double topPadding = 20;
  double rightpadding = 40;
  double h = 40;
  bool gs;

  void _showAlertDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: Text(
              'Error Signing In',
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

  Future<void> gsignIn(context) async {
    Navigator.of(context).pushNamed('/loading');
    gs = await auth.googleSignIn();
    Navigator.of(context).pop();
    if (gs == true) {
      Navigator.of(context).pushNamedAndRemoveUntil(
            '/navigation', (Route<dynamic> route) => false);
    } else {
      _showAlertDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Colors.deepPurple[300],
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.pink, Colors.deepPurple])),
          child: Center(
            child: ListView(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 100)),
                Container(
                  padding: EdgeInsets.only(
                      top: bottonPadding,
                      bottom: bottonPadding,
                      left: rightpadding,
                      right: rightpadding),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                      height: h,
                      width: double.infinity,
                      child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Center(
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 25),
                            ),
                          )),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width*.99,
                  padding: EdgeInsets.only(
                      top: bottonPadding,
                      bottom: bottonPadding,
                      left: rightpadding,
                      right: rightpadding),
                  child: SignInButton(
                    Buttons.Google,
                    text: "Sign in with Google",
                    padding: EdgeInsets.only(left: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      gsignIn(context);
                    },
                  ),
                ),
                /* SignInButton(
                  Buttons.Facebook,
                  text: "Sign in with Facebook",
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {},
                ), */
                Container(
                  padding:
                      EdgeInsets.only(left: rightpadding, right: rightpadding),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                      height: h,
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        "OR",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20),
                      )),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: bottonPadding,
                      bottom: bottonPadding,
                      left: rightpadding,
                      right: rightpadding),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                      height: h,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Color.fromARGB(255, 255, 255, 255),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/login_email');
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Sign in with Email',
                                style: TextStyle(),
                              ),
                              Icon(
                                Icons.email,
                                color: Colors.deepPurple[900],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: bottonPadding,
                      bottom: bottonPadding,
                      left: rightpadding,
                      right: rightpadding),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                      height: h,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/signUp_email');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Register with email",
                              style: TextStyle(
                                  color: Colors.black),
                            ),
                            Icon(
                                Icons.email,
                                color: Colors.deepPurple[900],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
