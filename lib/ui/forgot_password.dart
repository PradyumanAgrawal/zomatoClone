import 'package:flutter/material.dart';
import 'package:my_flutter_app/functionalities/auth.dart';

class ForgotPass extends StatefulWidget {
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  String email;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a valid email address.';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.1)),
                      Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Enter your email",
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
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01),
                            child: TextFormField(
                              validator: validateEmail,
                              onSaved: (input) {
                                email = input;
                              },
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
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  bool status =
                                      await AuthService().resetPassword(email);
                                  if (status) {
                                    final snackbar = SnackBar(
                                        content: Text(
                                            'Verification sent to you email address'));
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackbar);
                                  } else {
                                    final snackbar = SnackBar(
                                        content: Text(
                                            'Error occurred! Please check the entered address.'));
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackbar);
                                  }
                                }
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
