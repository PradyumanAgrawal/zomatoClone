import 'package:flutter/material.dart';
import 'package:my_flutter_app/ui/loading.dart';
import 'package:my_flutter_app/ui/main_screen.dart';
import 'package:my_flutter_app/ui/homescreen.dart';
import 'package:my_flutter_app/ui/description.dart';
import 'package:my_flutter_app/ui/navigation.dart';
import 'package:my_flutter_app/ui/login_email.dart';
import 'package:my_flutter_app/ui/products.dart';
import 'package:my_flutter_app/ui/profile.dart';
import 'package:my_flutter_app/ui/review_cart.dart';
import 'package:my_flutter_app/ui/signUp_email.dart';
import 'package:my_flutter_app/ui/login_screen.dart';
import 'package:my_flutter_app/ui/discover.dart';
import 'package:my_flutter_app/ui/imageViewer.dart';
import 'package:my_flutter_app/ui/cart.dart';
import 'package:my_flutter_app/ui/share.dart';
import 'package:my_flutter_app/ui/discover1.dart';
import 'package:my_flutter_app/ui/wishlist.dart';
import 'package:my_flutter_app/ui/feedback.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case '/main_screen':
        return MaterialPageRoute(
          builder: (_) => MainScreen(),
        );
      case '/imageViewer':
        return MaterialPageRoute(
          builder: (_) => ImageViewer(data: args),
        );
      case '/description':
        return MaterialPageRoute(
          builder: (_) => Description(document: args),
        );
      case '/discover_category':
        return MaterialPageRoute(
          builder: (_) => Discover(category: args),
        );
      case '/discover_shop':
        return MaterialPageRoute(
          builder: (_) => Discover(shopID: args),
        );
        case '/discover_offers':
        return MaterialPageRoute(
          builder: (_) => Discover(offer: args),
        );
      case '/homeScreen':
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
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
      case '/navigation':
        return MaterialPageRoute(
          builder: (_) => Navigation(),
        );
      case '/products':
        return MaterialPageRoute(
          builder: (_) => Products(),
        );
      case '/cart':
        return MaterialPageRoute(
          builder: (_) => Cart(navContext: args),
        );
        case '/share':
        return MaterialPageRoute(
          builder: (_) => Share(),
        );
        case '/discover1':
        return MaterialPageRoute(
          builder: (_) => Discover1(),
        );
        case '/wishlist':
        return MaterialPageRoute(
          builder: (_) => Wishlist(),
        );
        case '/profile':
        return MaterialPageRoute(
          builder: (_) => Profile(),
        );
        case '/feedback':
        return MaterialPageRoute(
          builder: (_) => FeedbackPage(),
        );
        case '/review_order':
        return MaterialPageRoute(
          builder: (_) => ReviewCart(navContext: args,),
        );
        case '/feedback':
        return MaterialPageRoute(
          builder: (_) => FeedbackPage(),
        );
        // If args is not of the correct type, return an error page.
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
