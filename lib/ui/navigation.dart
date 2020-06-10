import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './homeScreen.dart';
import './discover1.dart';
import './share.dart';
import 'package:my_flutter_app/functionalities/location_service.dart';
import 'orders.dart';

class Navigation extends StatefulWidget {
  Navigation({
    Key key,
  }) : super(key: key);
  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  String address = '';
  LatLng location;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> printLoc() async {
    LatLng loc = await LocationService().getLocation().then((value){
        location = value;

    });
    String add = await LocationService().getAddress(location).then((value){

        address = value;

    });

    // address = add;
    // location = loc;
    // setState(() {
    //   address = add;
    //   location = loc;
    // });
    print('------------------');
    print(location.latitude);
    print(address.replaceAll(' ', '').substring(0, 20));
    print('------------------');
  }

  @override
  void initState() {
    printLoc();
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
                add: address,
                location: location,
                navContext: context,
              ),
              Discover1(
                navContext: context,
              ),
              Orders(
                navContext: context,
              ),
              //Description(navContext: context,),
              Share(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 7.0,
            backgroundColor: Colors.white70,
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
                  Icons.shopping_basket,
                  color: Color(value),
                ),
                title: Text('Orders'),
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
      ),
    );
  }
}
