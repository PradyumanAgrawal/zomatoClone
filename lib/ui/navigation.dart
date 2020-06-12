import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './homeScreen.dart';
import './discover1.dart';
import './share.dart';
import 'orders.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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

  @override
  void initState() {
    super.initState();
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
              Discover1(
                navContext: context,
              ),
              Orders(
                navContext: context,
              ),
              //Description(navContext: context,),
              Share(
                navContext: context,
              ),
            ],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            height: 50,
            backgroundColor: Colors.white,
            color: Colors.deepPurple[800],
            //elevation: 7.0,
            //backgroundColor: Colors.white70,
            items: <Widget>[
              Icon(
                Icons.home,
                color: Colors.white,
              ),
              Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              Icon(
                Icons.shopping_basket,
                color: Colors.white,
              ),
              Icon(
                Icons.share,
                color:Colors.white,
              ),
            ],
            // items: const <BottomNavigationBarItem>[
            //   BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.home,
            //       color: Color(value),
            //     ),
            //     title: Text('Home'),
            //   ),
            //   BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.favorite,
            //       color: Color(value),
            //     ),
            //     title: Text('Discover'),
            //   ),
            //   BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.shopping_basket,
            //       color: Color(value),
            //     ),
            //     title: Text('Orders'),
            //   ),
            //   BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.share,
            //       color: Color(value),
            //     ),
            //     title: Text('Share'),
            //   ),
            // ],
            index: _selectedIndex,
            //selectedItemColor: Colors.black,
            onTap: _onItemTapped,
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
