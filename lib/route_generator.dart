import 'package:flutter/material.dart';
import 'package:my_flutter_app/loading.dart';
import './main_screen.dart';
import './navigation.dart';
import './login_email.dart';
import './signUp_email.dart';
import './login_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case '/navigation':
        return MaterialPageRoute(builder: (_) => Navigation());
      case '/main_screen':
        return MaterialPageRoute(
          builder: (_) => MainScreen(),
        );
      case '/login_screen':
        return MaterialPageRoute(
          builder: (_) => Login(),
        );
      case '/login_email':
        return MaterialPageRoute(
          builder: (_) => LoginEmail(),
        );
      case '/signUp_email':
        return MaterialPageRoute(
          builder: (_) => SignUP(),
        );
      case '/loading':
        return MaterialPageRoute(
          builder: (_) => Loading(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<void> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      //SystemNavigator.pop();
      return Scaffold(
        appBar: AppBar(
          title: Text('/'),
        ),
        body: Center(
          child: Text('/'),
        ),
      );
    });
  }
}
