import 'package:flutter/material.dart';
import './route_generator.dart';
import 'navigation.dart';
import 'login_email.dart';
import 'description.dart';
import 'discover.dart';



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
        accentColor: Colors.orange[300],
        dividerTheme: DividerThemeData(
          color: Colors.purple.withOpacity(0.5),
          space: 30,
          indent: 40,
          endIndent: 40,
        )
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      //'/main_screen',
      onGenerateRoute: RouteGenerator.generateRoute,
      //home: //MainScreen(),
      //Navigation(),
      //initialRoute: '/description',
      routes: {
        '/': (context) => Navigation(),
        '/description': (context) => Description(),
        '/discover': (context) => Discover(),
      },

    );
  }
}