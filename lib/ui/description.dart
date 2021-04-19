import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/productModel.dart';
import 'package:url_launcher/url_launcher.dart';

class Description extends StatefulWidget {
  final Map args;
  Description({this.args});

  @override
  _DescriptionState createState() => _DescriptionState(args['document']);
}

class _DescriptionState extends State<Description> {
  bool a = false;
  Product document;
  int photoIndex = 0;
  List<String> photos = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _DescriptionState(Product document) {
    this.document = document;
    //this.photos.addAll(document['catalogue']);
    photos.add(document.image);
  }
  String shopContact;
  LatLng shopLocation;
  int index = 0;
  int selectedVariant;
  @override
  Widget build(BuildContext context) {

    // for (int i = 0; i < document['sizesInStock'].length; i++) {
    //   if (document['sizesInStock'][i] == true) {
    //     setState(() {
    //       a = true;
    //     });
    //   }
    // }
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ]),
              ),
              Material(
                color: Colors.white,
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
                              return Hero(
                                tag: document.image,
                                child: CachedNetworkImage(
                                  imageUrl: photos[index],
                                  placeholder: (context, url) =>
                                      SpinKitChasingDots(
                                    color: Colors.purple,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
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
                      padding: EdgeInsets.only(top: 8, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          /* IconButton(
                            icon: Icon(Icons.arrow_back),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ), */
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
                                        .contains(document.productId);
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
                                                document.productId);
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
                  document.pName,
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
                  child: (document.discount == null
                              ? '0'
                              : document.discount) !=
                          '0'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '\u{20B9} ' + document.price,
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                                Text(
                                  ' ' + document.discount + "% off",
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
                                    (int.parse(document.price) *
                                            (1 -
                                                int.parse(
                                                        document.discount) /
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
                                '\u{20B9} ' + document.price,
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
                            document.description,
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
              // Visibility(
              //   visible: document['sizes'].length != 0,
              //   child: Divider(
              //     color: Colors.purple.withOpacity(0.5),
              //     height: 30,
              //     indent: 50,
              //     endIndent: 50,
              //   ),
              // ),
              // Visibility(
              //   visible: document['sizes'].length != 0,
              //   child: Padding(
              //     padding: EdgeInsets.only(left: 15.0),
              //     child: Text(
              //       'Variants',
              //       style: TextStyle(
              //           letterSpacing: 1.5,
              //           fontSize: 22.0,
              //           color: Colors.black,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 20.0),
              // Visibility(
              //   visible: document['sizes'].length != 0,
              //   child: Padding(
              //     padding: EdgeInsets.only(left: 15.0),
              //     child: Wrap(
              //       //crossAxisAlignment: WrapCrossAlignment.center,
              //       children: List.generate(document['sizes'].length, (index) {
              //         bool isSelected = (index == selectedVariant);
              //         double blur = isSelected ? 30 : 0;
              //         double offset = isSelected ? 20 : 0;
              //         double size = isSelected ? 60 : 50;
              //         Color color = isSelected
              //             ? Colors.deepPurple[500]
              //             : Colors.purple[300];
              //         return Visibility(
              //           visible: document['sizesInStock'][index],
              //           child: GestureDetector(
              //             onTap: () {
              //               setState(() {
              //                 selectedVariant = index;
              //               });
              //             },
              //             child: Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: AnimatedContainer(
              //                 height: size,
              //                 width: size,
              //                 duration: Duration(milliseconds: 500),
              //                 curve: Curves.easeOutQuint,
              //                 decoration: BoxDecoration(
              //                     color: color, // Colors.purple[200],
              //                     shape: BoxShape.circle,
              //                     boxShadow: [
              //                       BoxShadow(
              //                         color: Colors.black87,
              //                         blurRadius: blur,
              //                         offset: Offset(offset, offset),
              //                       )
              //                     ]),
              //                 child: Center(
              //                   child: Text(
              //                     document['sizes'][index],
              //                     textAlign: TextAlign.center,
              //                     style: TextStyle(
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         );
              //       }),
              //     ),
              //   ),
              // ),
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
                  future: null, //DBProvider.db.getShops(), //FirestoreService().getShop(document.shopID),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                          child: SpinKitChasingDots(color: Colors.deepPurple));
                    DocumentSnapshot shopDoc = snapshot.data;
                    shopContact = shopDoc['contact'];
                    shopLocation = new LatLng(
                        shopDoc['location']['geopoint'].latitude,
                        shopDoc['location']['geopoint'].longitude);
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
                          Divider(
                            color: Colors.purple.withOpacity(0.5),
                            height: 30,
                            indent: 50,
                            endIndent: 50,
                          ),
                          shopDoc['deliveryPerOrder'] == null ||
                                  shopDoc['deliveryPerOrder'] == 0
                              ? Container()
                              : Material(
                                  elevation: 0,
                                  child: Container(
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                            'The Seller charges \u{20B9} ' +
                                                shopDoc['deliveryPerOrder']
                                                    .toString() +
                                                ' per order.',
                                            style:
                                                TextStyle(color: Colors.grey))),
                                  )),
                        ],
                      ),
                    );
                  }),
              SizedBox(height: 20),
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
          height: 50.0,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            //SizedBox(width: 10.0),
            IconButton(
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
            IconButton(
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
            // Flexible(
            //   flex: 60,
            //   child: Container(
            //     decoration: BoxDecoration(
            //         color: (document['sizes'].toList().length == 0
            //                 ? document['inStock']
            //                 : a)
            //             ? Colors.deepPurple[700]
            //             : Colors.grey,
            //         borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(10),
            //             bottomLeft: Radius.circular(10))),
            //     child: Visibility(
            //       replacement: Center(
            //         child: Text('Out of Stock!!',
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold, color: Colors.white)),
            //       ),
            //       visible: document['sizes'].toList().length == 0
            //           ? document['inStock']
            //           : a,
            //       child: Center(
            //         child: FlatButton(
            //           onPressed: () async {
            //             print('pressed');
            //             int status;
            //             if (document['sizes'].length != 0 &&
            //                 selectedVariant != null) {
            //               status = await FirestoreService().addToCart(
            //                   document.documentID,
            //                   1,
            //                   document['sizes'][selectedVariant],
            //                   false,
            //                   document);
            //             } else if (document['sizes'].length == 0) {
            //               status = await FirestoreService().addToCart(
            //                   document.documentID, 1, '', false, document);
            //             } else {
            //               final snackbar = SnackBar(
            //                   content: Text('Please select a variant'));
            //               _scaffoldKey.currentState.showSnackBar(snackbar);
            //             }

            //             if (status == 2) {
            //               final snackbar = SnackBar(
            //                   content: Text('Product added to the cart!'));
            //               _scaffoldKey.currentState.showSnackBar(snackbar);
            //             } else if (status == 1) {
            //               final snackbar = SnackBar(
            //                   content:
            //                       Text('This product is already in the cart'));
            //               _scaffoldKey.currentState.showSnackBar(snackbar);
            //             } else if (status == 0) {
            //               final snackbar = SnackBar(
            //                   content: Text('Something went wrong!!!'));
            //               _scaffoldKey.currentState.showSnackBar(snackbar);
            //             }
            //           },
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: <Widget>[
            //               Icon(
            //                 Icons.add_shopping_cart,
            //                 color: Colors.white,
            //               ),
            //               SizedBox(
            //                 width: 10,
            //               ),
            //               Text(
            //                 'Add to Cart',
            //                 style: TextStyle(
            //                     fontSize: 15.0,
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.bold),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ]),
        ),
      ),
    );
  }
}
