import 'package:flutter/material.dart';
import 'package:my_flutter_app/functionalities/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'myApp.dart';
import 'navigation.dart';

class DrawerWidget extends StatefulWidget {
  BuildContext navContext;
  DrawerWidget({this.navContext});
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  AuthService auth = new AuthService();
  String userEmail;

  Future<void> _readEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
    });
  }

  Future<void> _logout(context) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: Text(
              'Logout ?',
              style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    auth.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => MyApp()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text('Yes',
                  style: TextStyle(fontSize: 18.0))),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('No',
                  style: TextStyle(fontSize: 18.0)))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _readEmail();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.deepPurple[300],
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(userEmail==null?'':userEmail),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple[100],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Navigator.of(context).pushAndRemoveUntil(
              //           MaterialPageRoute(
              //               builder: (context) => Navigation()),
              //           (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Wishlist'),
            onTap: () {
              Navigator.of(widget.navContext).pushNamed('/wishlist');
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Order History'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.backspace),
            title: Text('Logout'),
            onTap: () {
              _logout(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
