import 'package:flutter/material.dart';
import 'main.dart';
import 'main_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double bottonPadding = 10;
  double topPadding = 20;
  double rightpadding = 40;
  double h = 40;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 144, 28, 238),
        body: Center(
          child: Column(
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
                        child: Text(
                          "Login Your Account",
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
                      onPressed: () {},
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Continue with Google',
                              style: TextStyle(),
                            ),
                            Expanded(
                                child: Icon(
                              Icons.message,
                              color: Color.fromARGB(255, 144, 28, 238),
                            )),
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
                      color: Color.fromARGB(255, 255, 255, 255),
                      onPressed: () {},
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Continue with Facebook',
                              style: TextStyle(),
                            ),
                            Expanded(
                                child: Icon(
                              Icons.message,
                              color: Color.fromARGB(255, 144, 28, 238),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
                          children: <Widget>[
                            Text(
                              'Continue with Email',
                              style: TextStyle(),
                            ),
                            Expanded(
                                child: Icon(
                              Icons.email,
                              color: Color.fromARGB(255, 144, 28, 238),
                            )),
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
                      color: Color.fromARGB(255, 144, 28, 238),
                      onPressed: () {},
                      splashColor: Color.fromARGB(255, 144, 28, 238),
                      child: Text(
                        "Don't have account? Register",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
