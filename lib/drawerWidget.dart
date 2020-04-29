import 'package:flutter/material.dart';
import 'package:my_flutter_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  final String userEmail;
  DrawerWidget({
    Key key,
    @required this.userEmail,
  }) : super(key: key);

  Future<void> _logout(context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("loggedIn", "no");
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    MyApp()), (Route<dynamic> route) => false);
  }
  
  @override
  Widget build(BuildContext context) {
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
                            child: Icon(Icons.person, color:Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(userEmail),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Order History'),
                    onTap: (){},
                  ),
                  ListTile(
                    leading: Icon(Icons.feedback),
                    title: Text('Feedback'),
                    onTap: (){},
                  ),
                  ListTile(
                    leading: Icon(Icons.backspace),
                    title: Text('Logout'),
                    onTap: (){_logout(context);},
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About'),
                    onTap: (){},
                  ),
                ],
              ),
            );
  }
}