import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:connectivity/connectivity.dart';
import 'package:connectivity/connectivity.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

Future<bool> wait() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  //return Future.delayed(Duration(seconds: 3)).then((value) => true);
}

class _MainScreenState extends State<MainScreen> {
  LocalData localData = new LocalData();
  String userEmail = '';
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    // _connectivity.myStream.listen((source) {
    //   setState(() => _source = source);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // String networkStatus;
    // switch (_source.keys.toList()[0]) {
    //   case ConnectivityResult.none:
    //     networkStatus = "Offline";
    //     break;
    //   case ConnectivityResult.mobile:
    //     networkStatus = "Online";
    //     break;
    //   case ConnectivityResult.wifi:
    //     networkStatus = "Online";
    // }
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
                              // wait().then(
                              //   (value) {
                              //     if (value == true) {
                              //       Navigator.of(context)
                              //           .popAndPushNamed('/navigation');
                              //     }
                              //   },
                              // );

                              // if (networkStatus == 'online') {
                              //   Navigator.of(context)
                              //       .popAndPushNamed('/navigation');
                              // }

                              return Column(
                                children: <Widget>[
                                  StreamBuilder(
                                    stream: _connectivity.myStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data.values.toList()[0]) {
                                          _connectivity.disposeStream();
                                          Navigator.of(context)
                                              .popAndPushNamed('/navigation');
                                        }
                                      }
                                      return Center(
                                        child: SpinKitChasingDots(
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .17),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Made with ',
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            color: Colors.white),
                                      ),
                                      SpinKitPumpingHeart(
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    ],
                                  )
                                ],
                              );
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
                                      padding: const EdgeInsets.only(
                                          top: 13,
                                          bottom: 13,
                                          left: 30,
                                          right: 30),
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
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .17),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Made with ',
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            color: Colors.white),
                                      ),
                                      SpinKitPumpingHeart(
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    ],
                                  )
                                ],
                              );
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

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
