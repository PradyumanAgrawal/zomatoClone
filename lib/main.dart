import 'package:flutter/material.dart';
import './route_generator.dart';

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
      initialRoute:'/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}