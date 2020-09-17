import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:my_flutter_app/functionalities/location_service.dart';
import 'package:my_flutter_app/functionalities/streaming_shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
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
  String userId;
  StreamingSharedPreferences preferences;
  LocationPreferences locationPreference;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  initState() {
    StreamingSharedPreferences.instance.then((value) {
      setState(() {
        preferences = value;
        locationPreference = LocationPreferences(preferences);
        LocationService().getLocation().then((value) {
          setState(() {
            locationPreference.location.setValue(
                [value.latitude.toString(), value.longitude.toString()]);
          });
        });
      });
    });
    LocalData().getUid().then((value) {
      setState(() {
        userId = value;
      });
    });
    super.initState();
  }

  Future<bool> _onWillPop() async {
    setState(() {
      _selectedIndex = 0;
    });
    return false;
    /* return (await showDialog(
      context: context,
      builder: (context) => new CupertinoAlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the App'),
        actions: <Widget>[
          
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes', style: TextStyle(color:Colors.deepPurple[900]),),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No', style: TextStyle(color:Colors.pink)),
          ),
        ],
      ),
    )) ?? false; */
  }

  @override
  Widget build(BuildContext context) {
    if (locationPreference == null)
      return Center(
        child: SpinKitChasingDots(
          color: Colors.purple,
        ),
      );
    return PreferenceBuilder(
      preference: locationPreference.location,
      builder: (context, location) {
        if (location == null)
          return Center(
            child: SpinKitChasingDots(
              color: Colors.purple,
            ),
          );
        return MultiProvider(
          providers: [
            StreamProvider<DocumentSnapshot>.value(
              value: FirestoreService().getUser(userId),
            ),
            Provider<LocationPreferences>.value(value: locationPreference),
            Provider<List<String>>.value(value: location),
            StreamProvider<List<DocumentSnapshot>>.value(
              value: FirestoreService().getNearbyStores(
                LatLng(
                  double.parse(location[0]),
                  double.parse(location[1]),
                ),
              ),
            )
          ],
          child: new WillPopScope(
            onWillPop: _onWillPop,
            child: MaterialApp(
              home: Scaffold(
                body: <Widget>[
                  HomeScreen(
                    navContext: context,
                  ),
                  Discover1(
                    navContext: context,
                  ),
                  Orders(
                    navContext: context,
                  ),
                  // Share(
                  //   navContext: context,
                  // ),
                ][_selectedIndex],
                bottomNavigationBar: CurvedNavigationBar(
                  height: 50,
                  backgroundColor: Colors.white,
                  animationDuration: Duration(milliseconds: 250),
                  //animationCurve: Curves.elasticOut,
                  color: Colors.deepPurple[800],
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
                    // Icon(
                    //   Icons.share,
                    //   color: Colors.white,
                    // ),
                  ],

                  index: _selectedIndex,
                  onTap: _onItemTapped,
                ),
              ),
              debugShowCheckedModeBanner: false,
            ),
          ),
        );
      },
    );
  }
}
