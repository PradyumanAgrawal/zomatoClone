import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Description extends StatefulWidget {
  DocumentSnapshot document;
  Description({DocumentSnapshot document}) {
    this.document = document;
  }

  @override
  _DescriptionState createState() => _DescriptionState(document);
}

class _DescriptionState extends State<Description> {
  DocumentSnapshot document;
  int photoIndex = 0;
  List<String> photos = [];
  bool isFav;
  _DescriptionState(DocumentSnapshot document) {
    this.document = document;
    //this.photos.addAll(document['catalogue']);
    for (int i = 0; i < document['catalogue'].length; i++) {
      String img = document['catalogue'][i];
      photos.add(img);
    }
    this.isFav = document['isFav'];
  }

  void _previousImage() {
    setState(() {
      photoIndex = photoIndex > 0 ? photoIndex - 1 : 0;
    });
  }

  void _nextImage() {
    setState(() {
      photoIndex = photoIndex < photos.length - 1 ? photoIndex + 1 : photoIndex;
    });
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          print('pressed');
                          Navigator.of(context).pushNamed('/imageViewer',
                              arguments: photos[index]);
                        },
                        child: Carousel(
                            onImageTap: null,
                            boxFit: BoxFit.cover,
                            images: List.generate(photos.length, (index) {
                              return CachedNetworkImage(
                                imageUrl: photos[index],
                                placeholder: (context, url) => SpinKitChasingDots(color:  Colors.purple,),
                                    //CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              );
                              //Image.network(photos[index]);
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
                          Material(
                            elevation: isFav ? 2 : 0,
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: isFav
                                    ? Colors.white
                                    : Colors.grey.withOpacity(0.2),
                              ),
                              child: IconButton(
                                icon: isFav
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : Icon(Icons.favorite_border),
                                onPressed: () {
                                  FirestoreService()
                                      .changeFav(document.documentID, isFav);
                                  setState(
                                    () {
                                      isFav = !isFav;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Product id: XXXX',
                  style: TextStyle(fontSize: 15.0, color: Colors.grey),
                ),
              ),
              SizedBox(height: 10.0),
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
              SizedBox(height: 10.0),
              Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: Text(
                            document['description'],
                            //'Product description xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
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
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: Container(
                            child: Text(
                              '\u{20B9}' + document['price'],
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
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
              Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 1 / 3,
                            child: Text(
                              'Shop Name :',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                'shop name enterprice',
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
                            width: MediaQuery.of(context).size.width * 1 / 3,
                            child: Text(
                              'Address :',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                'shop address xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
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
                            width: MediaQuery.of(context).size.width * 1 / 3,
                            child: Text(
                              'Contact info :',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 200,
                              child: Text(
                                'contact details',
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
              ),
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
            //SizedBox(width: 10.0),
            Flexible(
              flex: 20,
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Container(
                    height: 40.0,
                    width: 50.0,
                    color: Colors.white,
                    child: Icon(
                      Icons.share,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 20,
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Container(
                    height: 40.0,
                    width: 50.0,
                    color: Colors.white,
                    child: Icon(
                      Icons.call,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 60,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Center(
                  child: FlatButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.shopping_cart,
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
          ]),
        ),
      ),
    );
  }
}

class SelectedPhoto extends StatelessWidget {
  final int numberOfDots;
  final int photoIndex;

  SelectedPhoto({this.numberOfDots, this.photoIndex});

  Widget _inactivePhoto() {
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(4.0))),
      ),
    );
  }

  Widget _activePhoto() {
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, spreadRadius: 0.0, blurRadius: 2.0)
                ])),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];

    for (int i = 0; i < numberOfDots; ++i) {
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }

    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildDots(),
    ));
  }
}
