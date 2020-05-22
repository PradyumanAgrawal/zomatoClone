import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'catagories_products.dart';

class Discover1 extends StatefulWidget {
  BuildContext navContext;
  Discover1({BuildContext navContext}) {
    this.navContext = navContext;
  }
  @override
  _Discover1State createState() => _Discover1State();
}

class _Discover1State extends State<Discover1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[800],
        title: Text("Discover"),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: TabBar(
                unselectedLabelColor: Colors.deepPurple[800],
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: Colors.deepPurple[800]),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.grid_on),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Categories")
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.store),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Shops")
                      ],
                    ),
                  )
                ]),
          ),
          body: TabBarView(
            children: [
              StreamBuilder(
                stream: FirestoreService().getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  return GridView.builder(
                    itemCount: snapshot.data.documents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document =
                          snapshot.data.documents[index];
                      List productReferences = document['products'];
                      return GestureDetector(
                          onTap: () {
                            Navigator.of(widget.navContext).pushNamed(
                                '/discover',
                                arguments: document.documentID);
                          },
                          child: Card(
                            shadowColor: Colors.deepPurple,
                            elevation: 5.0,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(document.documentID.substring(0,1).toUpperCase()+document.documentID.substring(1)),
                            ),
                          ));
                    },
                  );

                  /* ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document =
                          snapshot.data.documents[index];
                      List productReferences = document['products'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(widget.navContext).pushNamed(
                                  '/discover',
                                  arguments: document.documentID);
                            },
                            child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(15),
                              child: Text(
                                document.documentID,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
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
                  ); */
                },
              ),
              StreamBuilder(
                stream: FirestoreService().getStores(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  return ListView.builder(
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
                              child: Text(
                                document.documentID,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
