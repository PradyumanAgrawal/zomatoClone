import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/blocs/productBloc.dart';
import 'package:my_flutter_app/blocs/shopBloc.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:my_flutter_app/functionalities/location_service.dart';
import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/functionalities/streaming_shared_preferences.dart';
import 'package:my_flutter_app/models/productModel.dart';
import 'package:my_flutter_app/models/shopModel.dart';
import 'package:my_flutter_app/models/userModel.dart';
import 'package:provider/provider.dart';
import './drawerWidget.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'filter_location.dart';

class HomeScreen extends StatefulWidget {
  final BuildContext navContext;
  final String add;
  final LatLng location;
  HomeScreen({Key key, this.navContext, this.add, this.location})
      : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String add = '';
  List wishlist;
  bool isTyping = false;
  bool isSearching = false;
  User userProvider;
  List<Shop> nearByShops;
  //List<DocumentReference> nearByShopsReferences = [];
  LocationPreferences locationPreference;
  List<String> locationList;
  String userId;
  TextEditingController _controller = TextEditingController();
  String searchSubstring;
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

  initiateSearch(value, nearByShopsReferences) {
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

  void _showAlertDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
          content: Container(
            height: 200,
            alignment: Alignment.center,
            child: Text(
              add,
              style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            Material(
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.deepPurple, size: 30.0),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void setAddress() {
    LocationService()
        .getAddress(LatLng(
            double.parse(locationList[0]), double.parse(locationList[1])))
        .then((value) {
      setState(() {
        add = value;
      });
    });
  }

  void checkToken(String uid) async {
    String token = await LocalData().getToken();
    await FirestoreService().saveToken(token, uid);
  }

  final productBloc = ProductBloc();
  @override
  void dispose() {
    productBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<User>(context);
    userId = Provider.of<String>(context);
    //if (userProvider != null) checkToken(userProvider.documentID);

    if (Provider.of<List<Shop>>(context) != null) {
      nearByShops = List.from(Provider.of<List<Shop>>(context));
      //getShopRefList(nearByShopsSnapshots);
    }
    locationPreference = Provider.of<LocationPreferences>(context);
    locationList = Provider.of<List<String>>(context);
    if (locationList != null && locationList != ['0.0 ', '0.0']) setAddress();

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerWidget(
        navContext: widget.navContext,
      ),
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
              ((add == null) || (add == ''))
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.location_off,
                          color: Colors.white,
                        ),
                        onPressed: null,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _showAlertDialog(context);
                        },
                      ),
                    ),
              (userProvider == null)
                  ? Center(
                      child: SpinKitChasingDots(color: Colors.deepPurple),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                      child: InkWell(
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(widget.navContext)
                              .pushNamed('/cart', arguments: context);
                        },
                      )),
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            bottom: PreferredSize(
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: TextFormField(
                  onChanged: (value) {
                    searchSubstring = value;
                    //checkTyping(value);
                    //initiateSearch(value, nearByShopsReferences);
                  },
                  onFieldSubmitted: (value) {
                    Navigator.of(widget.navContext)
                                    .pushNamed('/discover', arguments: {
                                  'stream': 'allProducts',
                                  'searchSubstring' : value,
                                  'context': context
                                });
                  },
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Search",
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.purple,
                    ),
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
          isTyping
              ? (tempSearchStore.length == 0)
                  ? isSearching
                      ? SliverList(
                          delegate: SliverChildListDelegate(<Widget>[
                            Center(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: SpinKitChasingDots(
                                        color: Colors.deepPurple)))
                          ]),
                        )
                      : SliverList(
                          delegate: SliverChildListDelegate(<Widget>[
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Text('No Results Found!'),
                            ))
                          ]),
                        )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          print(tempSearchStore[index]);
                          return itemCard(
                              tempSearchStore[index].data['name'],
                              tempSearchStore[index].data['catalogue'][0],
                              tempSearchStore[index].data['description'],
                              wishlist
                                  .contains(tempSearchStore[index].documentID),
                              tempSearchStore[index].data['price'],
                              tempSearchStore[index].data['discount'] != null
                                  ? tempSearchStore[index].data['discount']
                                  : '0',
                              tempSearchStore[index],
                              widget.navContext);
                        },
                        childCount: tempSearchStore.length,
                      ),
                    )
              : SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Top Stores Nearby",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),
                            OutlineButton(
                              onPressed: () async {
                                final LatLng result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterLocation(),
                                  ),
                                );
                                if (result != null) {
                                  locationPreference.location.setValue([
                                    result.latitude.toString(),
                                    result.longitude.toString()
                                  ]);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Location Updated!'),
                                  ));
                                  // LocationService()
                                  //     .getAddress(result)
                                  //     .then((value) {
                                  //   setState(() {
                                  //     add = value;
                                  //     Scaffold.of(context)
                                  //         .showSnackBar(SnackBar(
                                  //       content: Text('Location Updated!'),
                                  //     ));
                                  //   });
                                  // });
                                }
                              },
                              shape: StadiumBorder(),
                              splashColor: Colors.purple,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Change",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  ),
                                  Icon(Icons.location_on),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Store(
                        navContext: widget.navContext,
                        locationPreference: locationPreference,
                        locationList: locationList,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Super Offers",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            OutlineButton(
                              onPressed: () {
                                Navigator.of(widget.navContext)
                                    .pushNamed('/discover', arguments: {
                                  'stream': 'offer',
                                  'context': context
                                });
                              },
                              child: Text(
                                "View All",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                              shape: StadiumBorder(),
                              splashColor: Colors.purple,
                            ),
                          ],
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          List<String> posters = [
                            'https://cdnb.artstation.com/p/assets/images/images/025/858/179/large/ruchita-ghatage-food-poster.jpg?1587143002',
                            'https://penji.co/wp-content/uploads/2020/12/Food_Poster_Design_Examples_and_Tips_for_Getting_Customers-min.jpg',
                            'https://i.ytimg.com/vi/WGyqJ-rqqtY/maxresdefault.jpg',
                            'https://i.pinimg.com/originals/63/37/90/633790eda4fc3d35065ebe3088c7ee72.jpg'
                          ];
                          return Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: Carousel(
                              onImageTap: null,
                              boxFit: BoxFit.cover,
                              images: List.generate(
                                posters.length,
                                (index) {
                                  return CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: posters[index],
                                    placeholder: (context, url) =>
                                        SpinKitChasingDots(
                                      color: Colors.purple,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  );
                                },
                              ),
                              autoplay: true,
                              dotSize: 5.0,
                              dotColor: Colors.black,
                              dotIncreasedColor: Colors.purple,
                              dotBgColor: Colors.transparent,
                              indicatorBgPadding: 2.0,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Products",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            OutlineButton(
                              onPressed: () {
                                Navigator.of(widget.navContext)
                                    .pushNamed('/discover', arguments: {
                                  'stream': 'allProducts',
                                  'context': context
                                });
                              },
                              shape: StadiumBorder(),
                              splashColor: Colors.purple,
                              child: Text(
                                "Explore",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // (userProvider == null)
                      //     ? Center(
                      //         child:
                      //             SpinKitChasingDots(color: Colors.deepPurple),
                      //       )
                      //     :
                      Builder(
                        builder: (context) {
                          //wishlist = userProvider['wishlist'];
                          // if (nearByShops.isEmpty)
                          //   return Center(
                          //     child: Column(
                          //       children: <Widget>[
                          //         Image.asset(
                          //             'assets/images/comingSoon.png'),
                          //         Text(
                          //           'Coming to your place soon!',
                          //           style: TextStyle(
                          //             color: Colors.grey,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          return StreamBuilder(
                            stream: productBloc.products,
                            //FirestoreService().getHomeProducts(nearByShopsReferences),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: SpinKitChasingDots(
                                    color: Colors.deepPurple,
                                  ),
                                );
                              if (snapshot.data.length == 0)
                                return Center(
                                    child: Text('Go to explore products'));
                              return Center(
                                child: Wrap(
                                  runSpacing: 2,
                                  spacing: 2,
                                  children: List.generate(
                                    snapshot.data.length,
                                    (index) {
                                      Product document = snapshot.data[index];
                                      bool inWishlist = true;
                                      //  wishlist
                                      //     .contains(document.documentID);
                                      return _singleProd(
                                          "Index $index",
                                          document,
                                          widget.navContext,
                                          inWishlist);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Divider(
                        color: Colors.purple.withOpacity(0.5),
                        height: 80,
                        indent: 50,
                        endIndent: 50,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'zomatoClone ',
                              style: TextStyle(
                                  letterSpacing: 2, color: Colors.grey),
                            ),
                            SpinKitPumpingHeart(
                              size: 16,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
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
      DocumentSnapshot document,
      BuildContext navContext) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: InkWell(
        onTap: () {
          Navigator.of(navContext).pushNamed('/description',
              arguments: {'document': document, 'providerContext': context});
        },
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          shadowColor: Colors.purple,
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 10),
            child: Container(
              height: 180,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 12,
                    child: Hero(
                      tag: imgPath,
                      child: Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(imgPath),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.0),
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
                                      name,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
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
                                description,
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
                                Flexible(flex: 5, child: Container()),
                                Flexible(
                                  flex: 20,
                                  child: Material(
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(10),
                                    shadowColor: Colors.purple,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (document['inStock'])
                                            ? Colors.purple
                                            : Colors.grey,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                      ),
                                      height: 40,
                                      child: Center(
                                        child: discount != '0'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '\u{20B9} ' + price,
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color: Colors.white
                                                            .withOpacity(0.5),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    "  " +
                                                        '\u{20B9} ' +
                                                        '${(int.parse(price) * (1 - int.parse(discount) / 100)).round()}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  )
                                                ],
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
                                  flex: 20,
                                  child: Material(
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(10),
                                    shadowColor: Colors.purple,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: (document['inStock'])
                                              ? Colors.purple[300]
                                              : Colors.grey[300],
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
                                          child: Visibility(
                                            visible: document['inStock'],
                                            replacement: Center(
                                              child: Text(
                                                'Out of stock!!',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            child: FlatButton(
                                              onPressed: () async {
                                                if (document['sizes'].length ==
                                                    0) {
                                                  int status =
                                                      await FirestoreService()
                                                          .addToCart(
                                                              document
                                                                  .documentID,
                                                              1,
                                                              '',
                                                              false,
                                                              document);
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
                                                } else {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Please open and select a size",
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

  _singleProd(
      name, Product document, BuildContext navContext, bool inWishlist) {
    return InkWell(
      onTap: () {
        Navigator.of(navContext).pushNamed('/description',
            arguments: {'document': document, 'providerContext': context});
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(25),
            shadowColor: Colors.purple,
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Hero(
                  tag: document.image,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: MediaQuery.of(context).size.width * 0.46,
                    height: MediaQuery.of(context).size.width * 0.46,
                    child: CachedNetworkImage(
                      imageUrl: document.image,
                      filterQuality: FilterQuality.low,
                      fit: BoxFit.cover,
                    ),
                    decoration: BoxDecoration(
                      // image: DecorationImage(
                      //   image: NetworkImage(document['catalogue'][0]),
                      //   fit: BoxFit.cover,
                      // ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      enableFeedback: true,
                      icon: inWishlist
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red.withOpacity(0.7),
                            )
                          : Icon(Icons.favorite_border,
                              color: Colors.grey[900].withOpacity(0.7)),
                      onPressed: () {
                        //FirestoreService().addToWishlist(document.productId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Store extends StatefulWidget {
  final BuildContext navContext;
  final LocationPreferences locationPreference;
  final List<String> locationList;
  final List<DocumentSnapshot> nearByShopsSnapshots;
  Store(
      {this.navContext,
      this.locationPreference,
      this.locationList,
      this.nearByShopsSnapshots});
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  String f(String name) {
    List<String> n = name.split(' ');
    for (int i = 0; i < n.length; i++) {
      n[i] =
          n[i].substring(0, 1).toUpperCase() + n[i].substring(1).toLowerCase();
    }
    String nam = n.join(' ');
    return nam;
  }

  final shopBloc = ShopBloc();
  @override
  void dispose() {
    shopBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      child: (widget.locationList == ['', ''])
          ? Center(child: Text('Location not Found'))
          : StreamBuilder(
              stream:
                  //DBProvider.db.getShops(),
                  shopBloc.shops,
              // FirestoreService().getNearbyStores(LatLng(
              //     double.parse(widget.locationList[0]),
              //     double.parse(widget.locationList[1]))),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                      child: SpinKitChasingDots(color: Colors.deepPurple));
                return snapshot.data.length == 0
                    ? Center(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Shops coming soon ',
                            style:
                                TextStyle(letterSpacing: 2, color: Colors.grey),
                          ),
                          SpinKitPumpingHeart(
                            size: 16,
                            color: Colors.grey,
                          )
                        ],
                      ))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Shop document = snapshot.data[index];
                          String type = document.type;
                          return InkWell(
                            onTap: () {
                              Navigator.of(widget.navContext)
                                  .pushNamed('/discover', arguments: {
                                'stream': 'shop',
                                'shopId': document.shopId.toString(),
                                'context': context
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 4, right: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.pink[200],
                                    ),
                                    width:
                                        MediaQuery.of(context).size.height / 13,
                                    padding: EdgeInsets.all(5.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                          'assets/typeIcons/$type.png'),
                                    ),
                                  ),
                                  Text(f(document.shopName),
                                      style: TextStyle(
                                        fontSize: 10,
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              }),
    );
  }
}
