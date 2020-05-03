import 'package:flutter/material.dart';
import 'package:my_flutter_app/ui/myApp.dart';
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
  runApp(MyApp());
}