import 'dart:html';

import 'package:flutter/material.dart';

class SignUP extends StatefulWidget {
  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {

 final emailField = Container(
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        child: TextFormField(
                          obscureText: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10,top:10),
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
                     final confirmPasswordField = Container(
                       
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
                            hintText: "Confirm Password",
                            fillColor: Colors.white ,
                            focusColor: Colors.white,
                            filled: true,
                            ),
                        ),
                     );
    final signUpButton = Container(
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
                                    child:Text('SIGN UP', style: TextStyle(),),
                                  ),
                                  ),

                        
                      ),
                    ),
                     );  
      
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text("SIGN UP",style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 144, 28, 238),
            body: Center(
          
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                         height: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.only(left: 20,right: 20),
                    
                    child: Column(
                      children: <Widget>[
                        
                        Padding(padding: EdgeInsets.only(top:10,bottom:10)),
                        Expanded(flex: 1,child: emailField),
                        Expanded(child: passwordField),
                        Expanded(child: confirmPasswordField),
                        Expanded(child: signUpButton),
                        
                      ],
                    ),
              color:Color.fromARGB(255, 144, 28, 238) ,

            ),
            
          ),
      
          
        ),
      ),
    );
}}