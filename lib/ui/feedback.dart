import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedbackPage extends StatefulWidget {
  final BuildContext navContext;
  FeedbackPage({this.navContext});
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String _feedback;
  final GlobalKey<FormState> _fKey = GlobalKey<FormState>();

  String validatefeedback(String value) {
    if (value.isEmpty)
      return 'Please enter a feedback';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        elevation: 0,
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Hero(tag:'feedback', child:Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.pink, Colors.deepPurple])),
          // width: MediaQuery.of(context).size.width * 0.7,
          //     height: MediaQuery.of(context).size.width * 0.9,
          //     padding: EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: Form(
              key: _fKey,
              child: ListView(shrinkWrap: false,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Image(
                      height: 200,
                      width: 200,
                      image: AssetImage('assets/images/feedback.png'),
                    ),
                    // SpinKitPumpingHeart(
                    //   size: 50,
                    //   color: Colors.white70,
                    // ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white70),
                        minLines: null,
                        validator: validatefeedback,
                        decoration: InputDecoration(
                          filled: true,
                          focusColor: Colors.white,
                          //fillColor: Colors.white,
                          enabled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          hintText: "I am loving this....",
                          hintStyle: TextStyle(color: Colors.white38),
                        ),
                        onChanged: (input) {
                          _feedback = input;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          //color: Colors.deepPurple[800],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Submit Feedback',
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          onPressed: () async {
                            if (_fKey.currentState.validate()) {
                              Navigator.of(context).pushNamed('/loading');
                              if (_feedback != '') {
                                await FirestoreService()
                                    .addFeedback(_feedback)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                    toastLength: Toast.LENGTH_LONG,
                                    msg: "Thanks for your Feedback",
                                  );
                                  //Navigator.of(widget.navContext).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/navigation',
                                      (Route<dynamic> route) => false);
                                }).catchError(() {
                                  Fluttertoast.showToast(
                                    msg: "Something went wrong!!!",
                                  );
                                  Navigator.of(context).pop();
                                });
                              }
                            }
                          }),
                    ),
                    SizedBox(height: 70),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Porsio ',
                            style: TextStyle(
                                letterSpacing: 2, color: Colors.white),
                          ),
                          SpinKitPumpingHeart(
                            size: 16,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),),
      ),
    );
  }
}
