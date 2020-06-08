import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:url_launcher/url_launcher.dart';

class Description extends StatefulWidget {
  final DocumentSnapshot document;
  Description({this.document});

  @override
  _DescriptionState createState() => _DescriptionState(document);
}

class _DescriptionState extends State<Description> {
  DocumentSnapshot document;
  int photoIndex = 0;
  List<String> photos = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _DescriptionState(DocumentSnapshot document) {
    this.document = document;
    //this.photos.addAll(document['catalogue']);
    for (int i = 0; i < document['catalogue'].length; i++) {
      String img = document['catalogue'][i];
      photos.add(img);
    }
  }
  String shopContact;
  LatLng shopLocation;
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                shadowColor: Colors.purpleAccent,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      height: 275.0,
                      child: InkWell(
                        onTap: () {
                          //print('pressed');
                          Navigator.of(context).pushNamed('/imageViewer',
                              arguments: photos[index]);
                        },
                        child: Carousel(
                            onImageTap: null,
                            boxFit: BoxFit.cover,
                            images: List.generate(photos.length, (index) {
                              return CachedNetworkImage(
                                imageUrl: photos[index],
                                placeholder: (context, url) =>
                                    SpinKitChasingDots(
                                  color: Colors.purple,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              );
                            }),
                            autoplay: false,
                            dotSize: 5.0,
                            dotColor: Colors.black,
                            dotIncreasedColor: Colors.purple,
                            dotBgColor: Colors.transparent,
                            indicatorBgPadding: 2.0,
                            onImageChange: (prev, next) {
                              index = next;
                              print(index);
                            }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Container(
                            height: 40.0,
                            width: 40.0,
                            child: FutureBuilder(
                              future: LocalData().getUid(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Center(
                                      child: SpinKitChasingDots(
                                    color: Colors.purple,
                                  ));
                                String userId = snapshot.data;
                                return StreamBuilder(
                                  stream: FirestoreService().getUser(userId),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return Center(
                                          child: SpinKitChasingDots(
                                        color: Colors.purple,
                                      ));
                                    DocumentSnapshot userDoc = snapshot.data;
                                    bool inWishlist = userDoc['wishlist']
                                        .contains(document.documentID);
                                    return Material(
                                      elevation: inWishlist ? 2 : 0,
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Container(
                                        height: 40.0,
                                        width: 40.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: inWishlist
                                              ? Colors.white
                                              : Colors.grey.withOpacity(0.2),
                                        ),
                                        child: IconButton(
                                          icon: inWishlist
                                              ? Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )
                                              : Icon(Icons.favorite_border),
                                          onPressed: () {
                                            FirestoreService().addToWishlist(
                                                document.documentID);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              /* Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Product id: ' + document['productId'],
                  style: TextStyle(fontSize: 15.0, color: Colors.grey),
                ),
              ),
              SizedBox(height: 10.0), */
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  document['name'],
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Container(
                  child: (document['discount'] == null
                              ? '0'
                              : document['discount']) !=
                          '0'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '\u{20B9} ' + document['price'],
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                                Text(
                                  ' ' + document['discount'] + "% off",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                SizedBox(width: 25),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                "  " +
                                    '\u{20B9} ' +
                                    (int.parse(document['price']) *
                                            (1 -
                                                int.parse(
                                                        document['discount']) /
                                                    100))
                                        .toStringAsFixed(2),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                '\u{20B9} ' + document['price'],
                                style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        flex: 20,
                        child: Container(
                          child: Text(
                            document['description'],
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey.withOpacity(1),
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  )),
              Divider(
                color: Colors.purple.withOpacity(0.5),
                height: 30,
                indent: 50,
                endIndent: 50,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Alternate Options',
                  style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Wrap(
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.pink,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ],
                  )),
              Divider(
                color: Colors.purple.withOpacity(0.5),
                height: 40,
                indent: 50,
                endIndent: 50,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Shop Details',
                  style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.0),
              FutureBuilder(
                  future: FirestoreService().getShop(document['shop']),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                          child: SpinKitChasingDots(color: Colors.deepPurple));
                    DocumentSnapshot shopDoc = snapshot.data;
                    shopContact = shopDoc['contact'];
                    shopLocation = new LatLng(shopDoc['location'].latitude,
                        shopDoc['location'].longitude);
                    return Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 1 / 3,
                                child: Text(
                                  'Shop Name :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    shopDoc['name'],
                                    //'shop name enterprice',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 1 / 3,
                                child: Text(
                                  'Address :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    shopDoc['address'],
                                    //'shop address xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 1 / 3,
                                child: Text(
                                  'Contact info :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: 200,
                                  child: Text(
                                    shopDoc['contact'],
                                    //'contact details',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
              Divider(
                color: Colors.purple.withOpacity(0.5),
                height: 30,
                indent: 50,
                endIndent: 50,
              ),
              /* Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Similar Products',
                  style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 200,
              ), 
              Divider(
                color: Colors.purple.withOpacity(0.5),
                height: 30,
                indent: 50,
                endIndent: 50,
              ),*/
            ],
          )
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 7.0,
        color: Colors.white70,
        child: Container(
          height: 40.0,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(width: 10.0),
            Flexible(
              flex: 20,
              child: IconButton(
                tooltip: 'Open the shop in Maps',
                icon: Icon(Icons.near_me, color: Colors.deepPurple[700]),
                onPressed: () async {
                  double latitude = shopLocation.latitude;
                  double longitude = shopLocation.longitude;
                  String googleUrl =
                      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                  if (await canLaunch(googleUrl)) {
                    await launch(googleUrl);
                  } else {
                    throw 'Could not open the map.';
                  }
                },
              ),
            ),
            Flexible(
              flex: 20,
              child: IconButton(
                tooltip: 'Call the shop',
                icon: Icon(Icons.call, color: Colors.deepPurple[700]),
                onPressed: () async {
                  if (shopContact != null) {
                    String url = 'tel:$shopContact';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                },
              ),
            ),
            Flexible(
              flex: 60,
              child: Container(
                decoration: BoxDecoration(
                    color: (document['inStock'])
                        ? Colors.purpleAccent
                        : Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Visibility(
                  replacement: Center(
                    child: Text('Out of Stock!!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  visible: document['inStock'],
                  child: Center(
                    child: FlatButton(
                      onPressed: () async {
                        print('pressed');
                        int status = await FirestoreService()
                            .addToCart(document.documentID, 1, false);

                        if (status == 2) {
                          final snackbar = SnackBar(
                              content: Text('Product added to the cart!'));
                          _scaffoldKey.currentState.showSnackBar(snackbar);
                        } else if (status == 1) {
                          final snackbar = SnackBar(
                              content:
                                  Text('This product is already in the cart'));
                          _scaffoldKey.currentState.showSnackBar(snackbar);
                        } else if (status == 0) {
                          final snackbar = SnackBar(
                              content: Text('Something went wrong!!!'));
                          _scaffoldKey.currentState.showSnackBar(snackbar);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
