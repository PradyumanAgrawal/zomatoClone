import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/blocs/productBloc.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/productModel.dart';
import 'package:my_flutter_app/models/shopModel.dart';
import 'package:my_flutter_app/models/userModel.dart';
import 'package:provider/provider.dart';

class Discover extends StatefulWidget {
  final BuildContext navContext;
  final String category;
  final String shopID;
  final String other;
  final Map args;
  Discover(
      {this.navContext, this.category, this.shopID, this.other, this.args});
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover>
    with SingleTickerProviderStateMixin {
  List wishlist;
  List<DocumentSnapshot> nearByShopsSnapshots;
  List<DocumentReference> nearByShopsReferences;
  List<Shop> shops;
  bool isVeg = false;
  bool isTyping = false;
  bool isSearching = false;
  TextEditingController _controller = TextEditingController();
  User userProvider;
  checkTyping(value) {
    if (value.length > 0) {
      setState(() {
        isTyping = true;
      });
    } else {
      setState(() {
        isTyping = false;
      });
    }
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      isSearching = true;
    });

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      FirestoreService()
          .searchByName(value, nearByShopsReferences)
          .then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          setState(() {
            queryResultSet.add(docs.documents[i]);
            tempSearchStore.add(docs.documents[i]);
          });
        }
        setState(() {
          isSearching = false;
        });
      });
    } else {
      setState(() {
        tempSearchStore = [];
        queryResultSet.forEach((element) {
          if (element.data['name'].startsWith(capitalizedValue)) {
            tempSearchStore.add(element);
          }
        });
        isSearching = false;
      });
    }
  }

  void getShopIdList(List<DocumentSnapshot> documentSnapshots) {
    nearByShopsReferences = [];
    for (int i = 0; i < documentSnapshots.length; i++) {
      nearByShopsReferences.add(documentSnapshots[i].reference);
    }
    // print("nearByShopsId ------->");
    // print(nearByShopsReferences);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //var productList = new List<Product>();
  Future<dynamic> stream;
  String currentStream;
  String searchSubstring;
  int flag = 0;
  @override
  Widget build(BuildContext context) {
    // shops =
    //     List.from(Provider.of<List<Shop>>(widget.args['context']));
    //getShopIdList(nearByShopsSnapshots);
    //userProvider = Provider.of<User>(widget.navContext);
    if (false)
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[800],
          title: Text(
            "zomatoClone",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/question.png'),
              Text(
                'No products found!',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    currentStream = widget.args['stream'];
    if (flag == 0) {
      if (widget.args['stream'] == 'category') {
        stream = DBProvider.db.getCategoryProducts(widget.args['category']);
      } else if (widget.args['stream'] == 'shop') {
        stream = DBProvider.db.getShopProducts(widget.args['shopId']);
      } else if (widget.args['stream'] == 'allProducts') {
        stream = DBProvider.db.getProducts();
      } else if (widget.args['stream'] == 'offer') {
        stream = DBProvider.db.getOfferProducts();
      } else if (widget.args['stream'] == 'search') {
        searchSubstring = widget.args['searchSubstring'];
        stream =
            DBProvider.db.getSearchProducts(widget.args['searchSubstring']);
      }
    }

    return Scaffold(
      //drawer: DrawerWidget(),
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.deepPurple[800],
          foregroundColor: Colors.white,
          //overlayOpacity: 0.2,
          children: [
            SpeedDialChild(
                child: Icon(
                  LineAwesomeIcons.sort,
                ),
                label: "price : high to low",
                backgroundColor: Colors.purple[300],
                onTap: () {
                  setState(() {
                    flag = 1;
                    isVeg = isVeg;
                    if (currentStream == 'category')
                      stream = DBProvider.db.getCustomSortProducts(
                          widget.args['stream'],
                          'desc',
                          widget.args['category'],
                          isVeg);
                    else if (currentStream == 'shop')
                      stream = DBProvider.db.getCustomSortProducts(
                          widget.args['stream'],
                          'desc',
                          widget.args['shopId'],
                          isVeg);
                    else if (currentStream == 'allProducts')
                      stream = DBProvider.db.getCustomSortProducts(
                          widget.args['stream'], 'desc', '', isVeg);
                    else if (currentStream == 'offer')
                      stream = DBProvider.db.getCustomSortProducts(
                          widget.args['stream'], 'desc', '', isVeg);
                    else if (currentStream == 'search')
                      stream = DBProvider.db.getCustomSortProducts(
                          currentStream, 'desc', searchSubstring, isVeg);
                  });
                }),
            SpeedDialChild(
                child: Icon(
                  LineAwesomeIcons.sort,
                ),
                label: "price : low to high",
                backgroundColor: Colors.purple[300],
                onTap: () {
                  setState(() {
                    flag = 1;
                    isVeg = isVeg;
                    if (currentStream == 'category')
                      stream = DBProvider.db.getCustomSortProducts(
                          widget.args['stream'],
                          'asc',
                          widget.args['category'],
                          isVeg);
                    else if (currentStream == 'shop')
                      stream = DBProvider.db.getCustomSortProducts(
                          widget.args['stream'],
                          'asc',
                          widget.args['shopId'],
                          isVeg);
                    else if (currentStream == 'allProducts')
                      stream = DBProvider.db.getCustomSortProducts(
                          widget.args['stream'], 'asc', '', isVeg);
                    else if (currentStream == 'offer')
                      stream = DBProvider.db.getCustomSortProducts(
                          widget.args['stream'], 'asc', '', isVeg);
                    else if (currentStream == 'search')
                      stream = DBProvider.db.getCustomSortProducts(
                          currentStream, 'asc', searchSubstring, isVeg);
                  });
                }),
            SpeedDialChild(
                child: Icon(
                  LineAwesomeIcons.heart,
                ),
                label: (!isVeg) ? "Veg" : "Clear Veg",
                backgroundColor: Colors.purple[300],
                onTap: () {
                  setState(() {
                    isVeg = !isVeg;
                  });
                  //_showMyDialog();
                })
          ]),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            backgroundColor: Colors.deepPurple[800],
            title: Text(
              "zomatoClone",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.only(right: 10.0, top: 10.0),
              //   child: FutureBuilder(
              //     future: LocalData().getUid(),
              //     builder: (BuildContext context, AsyncSnapshot snapshot) {
              //       if (!snapshot.hasData) {
              //         return Container();
              //       }
              //       String uid = snapshot.data;
              //       return StreamBuilder(
              //         stream: FirestoreService().getUser(uid),
              //         builder: (BuildContext context, AsyncSnapshot snap) {
              //           if (!snap.hasData) {
              //             return Container();
              //           }
              //           var len =
              //               snap.data['cart'].keys.toList().length.toString();
              //           return Badge(
              //             child: InkWell(
              //                 child: Icon(
              //                   Icons.shopping_cart,
              //                   color: Colors.white,
              //                 ),
              //                 onTap: () {
              //                   Navigator.of(context).pushNamed('/cart',
              //                       arguments: widget.args['context']);
              //                 }),
              //             badgeContent: Text(
              //               len,
              //               style: TextStyle(color: Colors.white),
              //             ),
              //             animationType: BadgeAnimationType.slide,
              //             showBadge: len != '0',
              //           );
              //         },
              //       );
              //     },
              //   ),
              // ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            bottom: PreferredSize(
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  //color: Colors.deepPurple[800],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      flag = 1;
                      currentStream = 'search';
                      searchSubstring = value;
                      stream = DBProvider.db.getSearchProducts(value);
                    });
                  },
                  onFieldSubmitted: (value) {
                    if (value != '')
                      setState(() {
                        currentStream = 'search';
                        flag = 1;
                        searchSubstring = value;
                        stream = DBProvider.db.getSearchProducts(value);
                      });
                  },
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Search",
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.search, color: Colors.purple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 14.0,
                    ),
                  ),
                ),
              ),
              preferredSize: Size(50, 80),
            ),
          ),
          FutureBuilder(
            future: null,
            //LocalData().getUid(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // if (!snapshot.hasData)
              //   return SliverList(
              //     delegate: SliverChildListDelegate(<Widget>[
              //       Center(
              //           child: Padding(
              //               padding:
              //                   const EdgeInsets.symmetric(vertical: 30),
              //               child: SpinKitChasingDots(
              //                   color: Colors.deepPurple)))
              //     ]),
              //   );
              // String userId = snapshot.data;

              return FutureBuilder(
                future: stream,
                //stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData)
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child:
                                  SpinKitChasingDots(color: Colors.deepPurple),
                            ),
                          ),
                        ],
                      ),
                    );
                  if (snapshot.data.length == 0)
                    return SliverList(
                      delegate: SliverChildListDelegate(<Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 50),
                            Image.asset('assets/images/noProducts.png'),
                            Text('No Products Yet!!',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ]),
                    );
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Product document = snapshot.data[index];
                        return itemCard(
                            document.pName,
                            document.image,
                            document.description,
                            true,
                            document.price.toString(),
                            document.discount != null
                                ? document.discount.toString()
                                : '0',
                            document,
                            context);
                      },
                      childCount: snapshot.data.length,
                    ),
                  );
                },
              );
              /* return SliverList(delegate: SliverChildBuilderDelegate(
                            (context, index){
                              return Text(wishlist[index]);
                            },
                            childCount: wishlist.length
                          )); */
            },
          ), /* SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      FutureBuilder(
                        future: LocalData().getUid(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                                child: SpinKitChasingDots(
                                    color: Colors.deepPurple));
                          String userId = snapshot.data;
                          return StreamBuilder(
                            stream: FirestoreService().getUser(userId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                    child: SpinKitChasingDots(
                                  color: Colors.purple,
                                ));
                              DocumentSnapshot document = snapshot.data;
                              wishlist = document['wishlist'];
                              return StreamBuilder(
                                stream: stream,
                                // (widget.category != null)
                                //     ? FirestoreService()
                                //         .getProductsFromCategory(widget.category)
                                //     : FirestoreService().getProducts(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                      child: SpinKitChasingDots(
                                          color: Colors.deepPurple),
                                    );
                                  if (snapshot.data.documents.length == 0)
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(height: 50),
                                          Image.asset('assets/images/noProducts.png'),
                                          Text('No Products Yet!!',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.bold)),
                                        ],
                                      ),
                                    );
                                  return Column(
                                    children: List.generate(
                                      snapshot.data.documents.length,
                                      (index) {
                                        DocumentSnapshot document =
                                            snapshot.data.documents[index];
                                        return itemCard(
                                            document['name'],
                                            document['catalogue'][0],
                                            document['description'],
                                            wishlist.contains(
                                                document.documentID),
                                            document['price'],
                                            document['discount'] != null
                                                ? document['discount']
                                                : '0',
                                            document,
                                            context);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ), */
        ],
      ),
    );
  }

  Widget itemCard(
      String name,
      String imgPath,
      String description,
      bool inWishlist,
      String price,
      String discount,
      Product document,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/description', arguments: {
            'document': document,
            'providerContext': widget.args['context']
          });
        },
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          shadowColor: Colors.purple,
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 10),
            child: Container(
              //card
              height: 180,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 12,
                    child: Hero(
                      tag: document.image,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: 150.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(document.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Flexible(
                    flex: 20,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 7,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                            (2 / 3) *
                                            (3 / 4) -
                                        10,
                                    child: Text(
                                      document.pName,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                // Flexible(
                                //   flex: 1,
                                //   child: SizedBox(),
                                // ),
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    child: Material(
                                      elevation: inWishlist ? 2 : 0,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                (1 / 3) *
                                                (1 / 4),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (1 / 3) *
                                                (1 / 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (1 / 3) *
                                                  (1 / 8)),
                                          color: inWishlist
                                              ? Colors.white
                                              : Colors.grey.withOpacity(0.2),
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            icon: inWishlist
                                                ? Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  )
                                                : Icon(Icons.favorite_border),
                                            iconSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    (1 / 3) *
                                                    (1 / 8) -
                                                1,
                                            onPressed: () {
                                              // FirestoreService().addToWishlist(
                                              //     document.documentID);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 2 / 3,
                              child: Text(
                                document.description,
                                textAlign: TextAlign.left,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                //Flexible(flex: 5, child: Container()),
                                Flexible(
                                  flex: 50,
                                  child: Material(
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(10),
                                    shadowColor: Colors.purple,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (true)
                                            ? Colors.purple
                                            : Colors.grey,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                      ),
                                      height: 40,
                                      // width: MediaQuery.of(context).size.width *
                                      //     (1 / 3) *
                                      //     (1.7 / 3),
                                      child: Center(
                                        child: discount != '0'
                                            ? Text(
                                                "  " +
                                                    '\u{20B9} ' +
                                                    '${(int.parse(price) * (1 - int.parse(discount) / 100)).round()}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              )
                                            : Text(
                                                '\u{20B9} ' + price,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 40,
                                  child: Material(
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(10),
                                    shadowColor: Colors.purple,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.purple[300],
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                        ),
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (1 / 3) *
                                                (2.7 / 3),
                                        child: Center(
                                          child: FlatButton(
                                            onPressed: () async {
                                              String userId =
                                                  await LocalData().getUid();
                                              int status = await DBProvider.db
                                                  .updateCart(userId,
                                                      document.productId, 1);
                                              if (status == 2) {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Product added to the cart!",
                                                );
                                              } else if (status == 1) {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "This product is already in the cart",
                                                );
                                              } else if (status == 0) {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Something went wrong!!!",
                                                );
                                              }
                                            },
                                            child: Text(
                                              'Add To Cart',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
