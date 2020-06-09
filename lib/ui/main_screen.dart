import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

Future<bool> wait() {
  return Future.delayed(Duration(seconds: 3)).then((value) => true);
}

class _MainScreenState extends State<MainScreen> {
  LocalData localData = new LocalData();
  String userEmail = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.pink, Colors.deepPurple])),
          child: ListView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.1),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 250,
                            width: 250,
                          ),
                          Image.asset(
                            'assets/images/LOGO1.png',
                            height: 150,
                            width: 150,
                          ),
                          Positioned(
                              bottom: 10,
                              child: Text(
                                'Porsio',
                                style: TextStyle(
                                  letterSpacing: 10,
                                    fontSize: 35,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),

                              ))
                        ],
                      ),
                    ),
                    FutureBuilder(
                        future: localData.checkLoggedIn(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data == true) {
                              wait().then((value) {
                                Navigator.of(context)
                                    .popAndPushNamed('/navigation');
                              });
                              return Center(
                                  child: SpinKitThreeBounce(
                                color: Colors.white,
                              ));

                              // return FutureBuilder(
                              //   future: wait(),
                              //   builder: (context, snapshot) {
                              //     if (snapshot.hasData) {
                              //       Navigator.of(context)
                              //           .popAndPushNamed('/navigation');
                              //     }
                              //     return Center(
                              //         child: SpinKitChasingDots(
                              //       color: Colors.purple,
                              //     ));
                              //   },
                              // );
                              // return RaisedButton(
                              //     color: Color.fromARGB(255, 90, 14, 151),
                              //     padding:
                              //         EdgeInsets.only(left: 120, right: 120),
                              //     child: Text(
                              //       'Continue',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(
                              //         color: Color.fromARGB(255, 255, 255, 255),
                              //         fontSize: 15,
                              //       ),
                              //     ),
                              //     splashColor:
                              //         Color.fromARGB(255, 144, 28, 238),
                              //     elevation: 10,
                              //     onPressed: () {
                              //       Navigator.of(context)
                              //           .popAndPushNamed('/navigation');
                              //     });
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(
                                    height: 50,
                                  ),
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/login_screen');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 13,bottom: 13,
                                          left: 30, right: 30),
                                      child: Text(
                                        'Get Started',
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height:MediaQuery.of(context).size.height*.17),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Made with ', style: TextStyle(letterSpacing: 2,color:Colors.white),),
                                      SpinKitPumpingHeart(size:16,color: Colors.white,)
                                    ],
                                  )
                                ],
                              );
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: <Widget>[
                              //     Padding(
                              //       padding: EdgeInsets.only(
                              //         bottom: 50,
                              //       ),
                              //     ),
                              //     RaisedButton(
                              //         color: Color.fromARGB(255, 90, 14, 151),
                              //         padding: EdgeInsets.only(
                              //             left: 120, right: 120),
                              //         child: Text(
                              //           'SignUp',
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(
                              //             color: Color.fromARGB(
                              //                 255, 255, 255, 255),
                              //             fontSize: 15,
                              //           ),
                              //         ),
                              //         splashColor:
                              //             Color.fromARGB(255, 144, 28, 238),
                              //         elevation: 10,
                              //         onPressed: () {
                              //           Navigator.of(context)
                              //               .pushNamed('/signUp_email');
                              //         }),
                              //     RaisedButton(
                              //         materialTapTargetSize:
                              //             MaterialTapTargetSize.padded,
                              //         padding: EdgeInsets.only(
                              //             left: 120, right: 120),
                              //         child: Text(
                              //           'SignIn',
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(
                              //             color: Color.fromARGB(
                              //                 255, 255, 255, 255),
                              //             fontSize: 15,
                              //           ),
                              //         ),
                              //         color: Color.fromARGB(255, 90, 14, 151),
                              //         elevation: 10,
                              //         splashColor:
                              //             Color.fromARGB(255, 144, 28, 238),
                              //         onPressed: () {
                              //           Navigator.of(context)
                              //               .pushNamed('/login_screen');
                              //         }),
                              //   ],
                              // );
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
