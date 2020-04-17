import 'package:flutter/material.dart';
import 'main.dart';
import 'login_screen.dart';
import 'login_email.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding:EdgeInsets.only(top: 50)),
              Image.asset('assets/images/LOGO2.png',height: 200,width:200,),
               Expanded(
                 child:Column(
                  
                mainAxisAlignment: MainAxisAlignment.center, 
                 children: <Widget>[
                  
                  Padding(padding:EdgeInsets.only(bottom: 50,)), 
                  RaisedButton(
                  color: Color.fromARGB(255, 90, 14, 151),
                  padding: EdgeInsets.only(left: 120,right: 120),
                  child: 
                  Text('SignUp',
                  textAlign: TextAlign.center,
                  style:TextStyle(color: Color.fromARGB(255, 255, 255, 255),fontSize: 15,) ,),
                  splashColor: Color.fromARGB(255, 144, 28, 238),                  
                  elevation: 10,
                  onPressed:(){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                         );
                     }
                  ),
                  RaisedButton(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  padding: EdgeInsets.only(left: 120,right: 120),
                  child: 
                  Text('SignIn',
                  textAlign: TextAlign.center,
                  style:TextStyle(color: Color.fromARGB(255, 255, 255, 255),fontSize: 15,) ,),
                  color: Color.fromARGB(255, 90, 14, 151),
                  elevation: 10,
                  splashColor: Color.fromARGB(255, 144, 28, 238),
                  onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginEmail()),
                         );
                  }),
                 ],
               ))

            ],
          ),
          
          ),
         backgroundColor: Color.fromARGB(255, 144, 28, 238), 
      
      
    );
  }
}