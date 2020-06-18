import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {

  Map details;
  SuccessScreen({this.details});

  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      new FirebaseAnalyticsObserver(analytics: analytics);

  logPurchase() async {
    await analytics.logEvent(
      name: details['paymentMethod']+'_purchase',
      parameters: <String, dynamic>{
        'amount': details['amount'],
        'userID': details['userId'],
        'email': details['email'],
        'method': details['paymentMethod'],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    logPurchase();
    return Scaffold(
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/success.png'),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                        color: Colors.black,
                        child: Text(
                          "Continue Shopping",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/navigation', (Route<dynamic> route) => false);
                          //Navigator.popUntil(context, ModalRoute.withName("/"));
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
