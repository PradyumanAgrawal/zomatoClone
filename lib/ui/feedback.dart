import 'package:flutter/material.dart';
class FeedbackPage extends StatefulWidget {
   BuildContext navContext;
  FeedbackPage({BuildContext navContext}) {
    this.navContext = navContext;
  }
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Text("Feedback"),
      
    );
  }
}