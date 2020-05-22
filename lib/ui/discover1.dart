import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'drawerWidget.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class Discover1 extends StatefulWidget {
  BuildContext navContext;
  Discover1({BuildContext navContext}) {
    this.navContext = navContext;
  }
  @override
  _Discover1State createState() => _Discover1State();
}

class _Discover1State extends State<Discover1> {

  Map iconMap = {
    'tshirts': LineAwesomeIcons.tshirt,
    'shirt': LineAwesomeIcons.user_tie,
    'caps' : LineAwesomeIcons.hat_cowboy,
    'pant': LineAwesomeIcons.shirtsinbulk,
    'shoes' : LineAwesomeIcons.shoe_prints,
    'utilities' : LineAwesomeIcons.toilet_paper,
    'fitness' : LineAwesomeIcons.dumbbell,
    'books' : LineAwesomeIcons.book_open,
    'household' : LineAwesomeIcons.home,
    'beauty,health' : LineAwesomeIcons.heart,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                floating: true,
                pinned: false,
                snap: true,
                backgroundColor: Colors.deepPurple[800],
                title: Text(
                  "Discover",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  )
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                bottom: PreferredSize(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
                    decoration: BoxDecoration(
                      //color: Colors.deepPurple[800],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: TabBar(
                      tabs: [
                        Tab(
                          text: "Catagories",
                          icon: Icon(Icons.list),
                        ),
                        Tab(
                          text: "Shops",
                          icon: Icon(Icons.store),
                        )
                      ],
                    ),
                  ),
                  preferredSize: Size(50, 80),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              StreamBuilder(
                stream: FirestoreService().getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  return ListView.builder(
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
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    iconMap[document.documentID.toString()],
                                    //size: 60.0,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width:30),
                                  Text(
                                    document.documentID,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.deepPurpleAccent,
                            thickness: 0,
                            height: 0,
                            indent: 10,
                            endIndent: 10,
                          )
                        ],
                      );
                    },
                  );
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
