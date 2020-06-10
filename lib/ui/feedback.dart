import 'package:flutter/material.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:fluttertoast/fluttertoast.dart';



class FeedbackPage extends StatefulWidget {
   BuildContext navContext;
  FeedbackPage({BuildContext navContext}) {
    this.navContext = navContext;
  }
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String _feedback ;
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
        backgroundColor: Colors.deepPurple[800],
      ) ,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.only(left: 20, right: 20),
          child: Form(
              key: _fKey,
              child: ListView(
                  children: [
                    TextFormField(
                  validator: validatefeedback,
                  decoration: InputDecoration(
                  enabled: true,
                  border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 5)),
                  hintText: "I am loving this application" ,
                ),
                onChanged: (input) {
                    _feedback = input;
                  },
            ),
            FlatButton(
                  color: Colors.deepPurple[800],
                  child: Text('Submit Feedback',style: TextStyle(color: Colors.white),),
                  onPressed: () async {
                    if (_fKey.currentState.validate()) {
                      Navigator.of(context).pushNamed('/loading');
                      if (_feedback != '') {
                        await FirestoreService().addFeedback(_feedback).then((value){
                                 Fluttertoast.showToast(
                                   toastLength: Toast.LENGTH_LONG,
                              msg: "Thanks for your Feedback",
                            );
                            //Navigator.of(widget.navContext).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamedAndRemoveUntil(
            '/navigation', (Route<dynamic> route) => false);
                          
                              }
                              ).catchError((){
                                Fluttertoast.showToast(
                              msg: "Something went wrong!!!",
                            );
                          Navigator.of(context).pop();
                              });
                      }
                    }
                  }),
            ]
              ),
          ),
        ),
      ),
      
    );
  }
}