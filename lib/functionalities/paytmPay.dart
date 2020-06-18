import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/functionalities/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:my_flutter_app/functionalities/firestore_service.dart';

class PaymentScreen extends StatefulWidget {
  final String amount;
  final Map selectedAddress;
  final String mobileNo;
  final String userID;
  final String email;

  PaymentScreen(
      {this.amount,
      this.selectedAddress,
      this.mobileNo,
      this.userID,
      this.email});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController _webController;

  bool _loadingPayment = true;
  String _responseStatus = STATUS_LOADING;

  String _loadHTML() {
    return "<html> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='$PAYMENT_URL'><input type='hidden' name='orderID' value='ORDER_${DateTime.now().millisecondsSinceEpoch}'/>" +
        "<input  type='hidden' name='custID' value='${widget.userID}' />" +
        "<input  type='hidden' name='amount' value='${widget.amount}' />" +
        "<input type='hidden' name='custEmail' value='${widget.email}' />" +
        "<input type='hidden' name='custPhone' value='${widget.mobileNo}' />" +
        "</form> </body> </html>";
  }

  void getData() {
    _webController.evaluateJavascript("document.body.innerText").then((data) {
      var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      final checksumResult = responseJSON["status"];
      final paytmResponse = responseJSON["data"];
      if (paytmResponse["STATUS"] == "TXN_SUCCESS") {
        if (checksumResult == 0) {
          _responseStatus = STATUS_SUCCESSFUL;
          String txnID = paytmResponse["TXNID"];
          FirestoreService()
              .placeOrder(widget.selectedAddress, widget.mobileNo, txnID);
        } else {
          _responseStatus = STATUS_CHECKSUM_FAILED;
        }
      } else if (paytmResponse["STATUS"] == "TXN_FAILURE") {
        _responseStatus = STATUS_FAILED;
      }
      this.setState(() {});
    });
  }

  Widget getResponseScreen() {
    switch (_responseStatus) {
      case STATUS_SUCCESSFUL:
        return PaymentSuccessfulScreen(
            userID: widget.userID, amount: widget.amount, email: widget.email);
      case STATUS_CHECKSUM_FAILED:
        return CheckSumFailedScreen();
      case STATUS_FAILED:
        return PaymentFailedScreen();
    }
    return PaymentSuccessfulScreen();
  }

  @override
  void dispose() {
    _webController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: WebView(
                debuggingEnabled: true,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _webController = controller;
                  _webController.loadUrl(
                      new Uri.dataFromString(_loadHTML(), mimeType: 'text/html')
                          .toString());
                },
                onPageFinished: (page) {
                  if (page.contains("/process")) {
                    if (_loadingPayment) {
                      this.setState(() {
                        _loadingPayment = false;
                      });
                    }
                  }
                  if (page.contains("/paymentReceipt")) {
                    getData();
                  }
                },
              ),
            ),
            (_loadingPayment)
                ? Center(
                    child: SpinKitChasingDots(
                      color: Colors.purple,
                    ),
                  )
                : Center(),
            (_responseStatus != STATUS_LOADING)
                ? Center(child: getResponseScreen())
                : Center(),
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessfulScreen extends StatelessWidget {
  final String amount;
  final String userID;
  final String email;
  PaymentSuccessfulScreen({this.amount, this.email, this.userID});
  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      new FirebaseAnalyticsObserver(analytics: analytics);

  logPurchase() async {
    await analytics.logEcommercePurchase(
      currency: "INR",
      value: double.parse(amount),
      transactionId: email,
    );
    await analytics.logEvent(
      name: 'paytm_purchase',
      parameters: <String, dynamic>{
        'amount': amount,
        'userID': userID,
        'email': email,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    logPurchase();
    return Container(
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
    );
  }
}

class PaymentFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "OOPS!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Payment was not successful, Please try again Later!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
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
    );
  }
}

class CheckSumFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Oh Snap!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Problem Verifying Payment, If you balance is deducted please contact our customer support and get your payment verified!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
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
    );
  }
}
