import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'main_screen.dart';
import 'login_screen.dart';
=======
import './navigation.dart';
import './main_screen.dart';
>>>>>>> 428aa1570540b58d1a64fcf38d9aeb93182ef7e7

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Porsio",
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        primaryColorDark: Colors.deepPurple[900],
        primaryColorLight: Colors.deepPurple[100],
        accentColor: Colors.orange[300]
      ),
      debugShowCheckedModeBanner: false,
      home: //MainScreen(),
      Navigation(),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 428aa1570540b58d1a64fcf38d9aeb93182ef7e7
