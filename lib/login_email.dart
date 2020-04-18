import 'package:flutter/material.dart';
import 'main.dart';

class LoginEmail extends StatefulWidget {
  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final emailField = Container(
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        child: TextFormField(
                          obscureText: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 10)
                              ),
                            hintText: "xyz@gmail.com",
                            fillColor: Colors.white ,
                            focusColor: Colors.white,
                            filled: true,
                            ),
                        ),
                      );
    final passwordField = Container(
                       
                       padding: EdgeInsets.only(top: 10,bottom: 10),
                       child: TextFormField(
                         
                         obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 10)
                              ),
                            hintText: "Password",
                            fillColor: Colors.white ,
                            focusColor: Colors.white,
                            filled: true,
                            ),
                        ),
                     );
    final loginButton = Container(
                       padding: EdgeInsets.only(top: 10,bottom: 10),
                       child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: RaisedButton(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  onPressed:(){} ,
                                  child: Center(
                                    child:Text('LOGIN', style: TextStyle(),),
                                  ),
                                  ),

                        
                      ),
                    ),
                     );  
      final forgotPassword = FlatButton(
                  onPressed: (){
                    //forgot password screen
                  },
                  
                  splashColor: Color.fromARGB(255, 144, 28, 238) ,
                  textColor: Colors.white,
                  child: Text('Forgot Password'),
                );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
          body: Center(
        
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  height: 280,
                  width: 250,
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top:10,bottom:10)),
                      emailField,
                      passwordField,
                      loginButton,
                      forgotPassword,
                    ],
                  ),
            color:Color.fromARGB(255, 144, 28, 238) ,

          ),
        ),
        
      ),
    );
  }
}