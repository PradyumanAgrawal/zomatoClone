import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './homeScreen.dart';
import './discover.dart';
import './cart.dart';
import './share.dart';

class Navigation extends StatefulWidget {
  @override
  PortioHomeState createState() => PortioHomeState();
}

class PortioHomeState extends State<Navigation> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 25, color: Color(0xFF000000), fontWeight: FontWeight.normal);
  List<Widget> _widgetPages = <Widget>[
    HomeScreen(),
    Discover(),
    Cart(),
    Share(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    const value = 0xFF4A148C;
    return MaterialApp(
      home: Scaffold(
        body: _widgetPages.elementAt(_selectedIndex),
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
