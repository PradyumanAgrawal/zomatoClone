import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'discover.dart';
import 'catagories_product.dart';

class Discover1 extends StatefulWidget {
  @override
  _Discover1State createState() => _Discover1State();
}

class _Discover1State extends State<Discover1> {
  
  
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
        StreamBuilder(
          stream: FirestoreService().getCategories(),
          builder: (context,snapshot){
            if (!snapshot.hasData) return const Text('Loading...');
            return  ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document =
                              snapshot.data.documents[index];
                          List type = document['products'];
                      
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                              Navigator.push(
                                        context,
                                     MaterialPageRoute(
                                    builder: (context) => CatagoriesProduct(),
                                       ),
        );
                          print(type);  
      },
                                child: Container(
                                  margin: EdgeInsets.all(0),
                                  padding: EdgeInsets.all(15),
                                  child: Text(document.documentID,
                                      style: TextStyle(
                                        fontSize: 20,
                                      )
                                      ),
                                ),
                              
                              ),
                              Divider(
                                    color: Colors.deepPurpleAccent,
                                    thickness: 0,
                                    height: 0,
                                  )
                            ],
                          );
                        },
                      );
           

          },
                
        ),
         StreamBuilder(
          stream: FirestoreService().getStores(),
          builder: (context,snapshot){
            if (!snapshot.hasData) return const Text('Loading...');
            return  ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document =
                              snapshot.data.documents[index];
                          String type = document['type'];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  print(index);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(0),
                                  padding: EdgeInsets.all(15),
                                  child: Text(document.documentID,
                                      style: TextStyle(
                                        fontSize: 20,
                                      )
                                      ),
                                ),
                              
                              ),
                              Divider(
                                    color: Colors.deepPurpleAccent,
                                    thickness: 0,
                                    height: 0,
                                  )
                            ],
                          );
                        },
                      );
           

          },
                
        ),
      ]),
    )
    ),
);
  }
}

