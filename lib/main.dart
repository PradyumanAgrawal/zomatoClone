import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './route_generator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loggedIn = false;
  String userEmail = '';

  Future<void> _readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String check = prefs.getString("loggedIn");
      if (check == "yes") {
        setState(() {
          userEmail = prefs.getString("userEmail");
          _loggedIn = true;
        });
      } else {
        setState(() {
          _loggedIn = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _readData();
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
          )),
      debugShowCheckedModeBanner: false,
      initialRoute: _loggedIn ? '/navigation' : '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
