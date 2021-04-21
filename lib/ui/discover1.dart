import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/shopModel.dart';
import 'package:provider/provider.dart';
import 'drawerWidget.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class Discover1 extends StatefulWidget {
  final BuildContext navContext;
  Discover1({this.navContext});
  @override
  _Discover1State createState() => _Discover1State();
}

class _Discover1State extends State<Discover1> {
  Map iconMap = {
    'street food': LineAwesomeIcons.user_tie,
    'italian': LineAwesomeIcons.book_open,
    'chinese': LineAwesomeIcons.home,
    'health and diet': LineAwesomeIcons.heart,
    'asian': LineAwesomeIcons.atom,
    'beverages': LineAwesomeIcons.shopping_bag,
    'Electronics': LineAwesomeIcons.mobile
  };
  //List<String> locationList;
  DocumentSnapshot userProvider;
  String f(String name) {
    List<String> n = name.split(' ');
    for (int i = 0; i < n.length; i++) {
      n[i] =
          n[i].substring(0, 1).toUpperCase() + n[i].substring(1).toLowerCase();
    }
    String nam = n.join(' ');
    return nam;
  }

  @override
  Widget build(BuildContext context) {
    //locationList = Provider.of<List<String>>(context);
    //userProvider = Provider.of<DocumentSnapshot>(context);
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
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                  //   child: (userProvider == null)
                  //       ? Container()
                  //       : StreamBuilder(
                  //           stream: FirestoreService()
                  //               .getUser(userProvider.documentID),
                  //           builder:
                  //               (BuildContext context, AsyncSnapshot snap) {
                  //             if (!snap.hasData) {
                  //               return Container();
                  //             }
                  //             var len = snap.data['cart'].keys
                  //                 .toList()
                  //                 .length
                  //                 .toString();
                  //             return Badge(
                  //               child: InkWell(
                  //                 child: Icon(
                  //                   Icons.shopping_cart,
                  //                   color: Colors.white,
                  //                 ),
                  //                 onTap: () {
                  //                   Navigator.of(widget.navContext)
                  //                       .pushNamed('/cart', arguments: context);
                  //                 },
                  //               ),
                  //               badgeContent: Text(
                  //                 len,
                  //                 style: TextStyle(color: Colors.white),
                  //               ),
                  //               animationType: BadgeAnimationType.slide,
                  //               showBadge: len != '0',
                  //             );
                  //           },
                  //         ),
                  // ),
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
                        bottomRight: Radius.circular(20),
                      ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [Icon(Icons.store), Text("Shops")],
                            ),
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
              FutureBuilder(
                future: DBProvider.db.getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                        child: SpinKitChasingDots(color: Colors.deepPurple));
                  //List<Map> categories = DBProvider.db.getCategories();
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      String document = snapshot.data[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(widget.navContext).pushNamed(
                                '/discover',
                                arguments: {
                                  'category': document,
                                  'stream': 'category',
                                  'context': context
                                },
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    iconMap[document],
                                    //size: 60.0,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 30),
                                  Text(
                                    document,
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
              //(locationList == null)
              //     ? Center(child: Text('Location not Found'))
              //     :
              FutureBuilder(
                future: DBProvider.db.getShops(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: SpinKitChasingDots(color: Colors.deepPurple),
                    );
                  if (snapshot.data.length == 0)
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/noStore4.png'),
                          Text(
                            'No stores found around you',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Shop document = snapshot.data[index];
                      String type = document.type;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(widget.navContext).pushNamed(
                                '/discover',
                                arguments: {
                                  'stream': 'shop',
                                  'shopId': document.shopId.toString(),
                                  'context': context
                                },
                              );
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
                                    f(document.shopName),
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
