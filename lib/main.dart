import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/ui/myApp.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
/* 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var log = prefs.getString('loggedIn');
  print(log);
  runApp(MyApp(
    loggedIn: log != null ? (log == 'yes') ? true : false : false,
  ));
}
 */

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  runApp(
    MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      home: MyApp(),
    ),
  );
}
