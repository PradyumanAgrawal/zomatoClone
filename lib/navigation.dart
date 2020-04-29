import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './homeScreen.dart';
import './discover.dart';
import './cart.dart';
import './share.dart';
import './description.dart';


class Navigation extends StatefulWidget {
 final String userEmail;
  Navigation({
    Key key,
    @required this.userEmail,
  }) : super(key: key);
  @override
   NavigationState createState() =>  NavigationState();
}

class  NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userEmail);
    const value = 0xFF4A148C;
    return MaterialApp(
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            HomeScreen(),
            Discover(),
            Cart(),
            Description(),
            //Share,
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Color(value),
              ),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: Color(value),
              ),
              title: Text('Discover'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: Color(value),
              ),
              title: Text('Cart'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.share,
                color: Color(value),
              ),
              title: Text('Share'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
