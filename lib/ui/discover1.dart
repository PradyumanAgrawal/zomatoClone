import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'drawerWidget.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class Discover1 extends StatefulWidget {
  final BuildContext navContext;
  Discover1({this.navContext}) ;
  @override
  _Discover1State createState() => _Discover1State();
}

class _Discover1State extends State<Discover1> {
  Map iconMap = {
    "men's wear": LineAwesomeIcons.tshirt,
    'shirt': LineAwesomeIcons.user_tie,
    "men's accessories": LineAwesomeIcons.glasses,
    'shoes': LineAwesomeIcons.shoe_prints,
    'utilities': LineAwesomeIcons.toilet_paper,
    'fitness': LineAwesomeIcons.dumbbell,
    'books': LineAwesomeIcons.book_open,
    'household': LineAwesomeIcons.home,
    'beauty and health': LineAwesomeIcons.heart,
    'others': LineAwesomeIcons.atom,
    "women's accessories": LineAwesomeIcons.dice_d20,
    "women's wear": LineAwesomeIcons.female,
  };

  String f(String name){
    List<String> n = name.split(' ');
    for(int i=0; i<n.length; i++){
      n[i] = n[i].substring(0,1).toUpperCase()+n[i].substring(1).toLowerCase();
    }
    String nam = n.join(' ');
    return nam;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(navContext: widget.navContext),
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  /* IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ), */
                  Padding(
                padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                child: FutureBuilder(
                  future: LocalData().getUid(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    String uid = snapshot.data;
                    return StreamBuilder(
                      stream: FirestoreService().getUser(uid),
                      builder: (BuildContext context, AsyncSnapshot snap) {
                        if (!snap.hasData) {
                          return Container();
                        }
                        var len =
                            snap.data['cart'].keys.toList().length.toString();
                        return Badge(
                          child: InkWell(
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Navigator.of(widget.navContext).pushNamed(
                                    '/cart',
                                    arguments: widget.navContext);
                              }),
                          badgeContent: Text(len,style: TextStyle(color:Colors.white),),
                          animationType: BadgeAnimationType.slide,
                          showBadge: len != '0',
                        );
                      },
                    );
                  },
                ),
              ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                bottom: PreferredSize(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    decoration: BoxDecoration(
                      //color: Colors.deepPurple[800],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: TabBar(
                      labelColor: Colors.deepPurple[900],
                      unselectedLabelColor: Colors.white,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      tabs: [
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.format_list_bulleted),
                                  Text("Catagories")
                                ]),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [Icon(Icons.store), Text("Shops")]),
                          ),
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
                                  '/discover_category',
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
                                  SizedBox(width: 30),
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
                            indent: 20,
                            endIndent: 20,
                          )
                        ],
                      );
                    },
                  );
                },
              ),
              StreamBuilder(
                stream: FirestoreService().getAllStores(),
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
                              Navigator.of(widget.navContext).pushNamed(
                                  '/discover_shop',
                                  arguments: document.documentID);
                              print(index);
                            },
                            child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                        'assets/typeIcons/$type.png'),
                                  ),
                                  SizedBox(width: 30),
                                  Text(
                                    f(document['name']),
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
