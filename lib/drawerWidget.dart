import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text('User Name'),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100],
                    ),
                  ),
                  ListTile(
                    title: Text('Item 1'),
                    onTap: null,
                  ),
                  ListTile(
                    title: Text('Item 2'),
                    onTap: null,
                  ),
                ],
              ),
            );
  }
}