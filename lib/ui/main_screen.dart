import 'package:flutter/material.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  LocalData localData = new LocalData();
  String userEmail = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * .2),
                child: Image.asset(
                  'assets/images/LOGO2.png',
                  height: 200,
                  width: 200,
                ),
              ),
              FutureBuilder(
                  future: localData.checkLoggedIn(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == true) {
                        return RaisedButton(
                            color: Color.fromARGB(255, 90, 14, 151),
                            padding: EdgeInsets.only(left: 120, right: 120),
                            child: Text(
                              'Continue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 15,
                              ),
                            ),
                            splashColor: Color.fromARGB(255, 144, 28, 238),
                            elevation: 10,
                            onPressed: () {
                              Navigator.of(context)
                                  .popAndPushNamed('/navigation');
                            });
                      } else {
                        return Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 50,
                              ),
                            ),
                            RaisedButton(
                                color: Color.fromARGB(255, 90, 14, 151),
                                padding: EdgeInsets.only(left: 120, right: 120),
                                child: Text(
                                  'SignUp',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 15,
                                  ),
                                ),
                                splashColor: Color.fromARGB(255, 144, 28, 238),
                                elevation: 10,
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('/signUp_email');
                                }),
                            RaisedButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                padding: EdgeInsets.only(left: 120, right: 120),
                                child: Text(
                                  'SignIn',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 15,
                                  ),
                                ),
                                color: Color.fromARGB(255, 90, 14, 151),
                                elevation: 10,
                                splashColor: Color.fromARGB(255, 144, 28, 238),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('/login_screen');
                                }),
                          ],
                        ));
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 144, 28, 238),
      ),
    );
  }
}
