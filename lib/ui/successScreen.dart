import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
    );
  }
}
