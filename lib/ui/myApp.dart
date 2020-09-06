import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_flutter_app/functionalities/analytics.dart';
import 'package:my_flutter_app/functionalities/route_generator.dart';

class MyApp extends StatefulWidget {
  //final bool loggedIn;
  MyApp({
    Key key,
    //@required this.loggedIn,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Porsio",
      //navigatorObservers: [AnalyticsService().getObserver()],
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
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
      initialRoute: '/main_screen',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
