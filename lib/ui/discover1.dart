import 'package:flutter/material.dart';

class Discover1 extends StatefulWidget {
  @override
  _Discover1State createState() => _Discover1State();
}

class _Discover1State extends State<Discover1> {
  List<String> catagories = [
   "Shirt",
   "Pant",
   "T-shirt",
   "Sports Wear",
   "Shirt",
   "Pant",
   "T-shirt",
   "Sports Wear",
   "Shirt",
   "Pant",
   "T-shirt",
   "Sports Wear",
   ];
   List<String> shops = [
   "Mufti",
   "Jagadamba",
   "Nike",
   ] ;
   Widget catag(catagory){
     return Container(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(0)), 
                ListTile(
                  onTap: (){},
        title: Text(catagory),
        ),
        Divider(
          height: 0,
          thickness: 1,
          color: Colors.deepPurpleAccent, 
        )
        ],
       ),
       );
   } 
   Widget shopNames(shop){
     return Container(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(0)), 
                ListTile(
                  onTap: (){},
        title: Text(shop),
        ),
        Divider(
          height: 0,
          thickness: 1,
          color: Colors.deepPurpleAccent, 
        )
        ],
       ),
       );
   } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(backgroundColor: Colors.deepPurple,
      title: Text("Discovery"),
    ),
    body: DefaultTabController(length: 2, 
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: TabBar(
          tabs:[
          Tab(
            text: "Catagories"),
          Tab(
            text: "Shops")
        ]),
      ),
      body: TabBarView(children:[
        
        ListView(children: 
        catagories.map((catagory){
          return catag(catagory); 
        }).toList() 
        ),
        ListView(children: 
        shops.map((shop){
          return shopNames(shop) ; 
        }).toList() 
        ),
      ]),
    )
    ),
);
  }
}

