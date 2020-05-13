import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './homeScreen.dart';
import './discover.dart';
import './cart.dart';
import './share.dart';
import './description.dart';

class Navigation extends StatefulWidget {
  Navigation({
    Key key,
  }) : super(key: key);
  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /* Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  } */

  @override
  Widget build(BuildContext context) {
    const value = 0xFF4A148C;
    return new WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        home: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              HomeScreen(
                navContext: context,
              ),
              Discover(
                navContext: context,
              ),
              Cart(
                navContext: context,
              ),
              //Description(navContext: context,),
              Share(),
            ],
          ),
          bottomNavigationBar: Material(
            elevation: 7.0,
            color: Colors.white70,
            child: Container(
              child: BottomNavigationBar(
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
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
