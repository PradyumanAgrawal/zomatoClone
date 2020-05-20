import 'package:flutter/material.dart';
import 'package:my_flutter_app/ui/discover.dart';

class CatagoryProduct extends StatefulWidget {
  List products ; 
  var doc ; 
  CatagoryProduct({this.products,this.doc});
  @override
  _CatagoryProductState createState() => _CatagoryProductState(products,doc);
}

class _CatagoryProductState extends State<CatagoryProduct> {
  List products ;
  var doc ;  
  _CatagoryProductState(this.products,this.doc);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar( 
        backgroundColor: Colors.deepPurple[800],
        leading: IconButton(onPressed: (){
           Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back),
        ),
        title: Text(doc),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(products[0]),
          )
        ],

      ),
     //make changes here 
     //display the products which are in the database of catagories
    );
  }
}