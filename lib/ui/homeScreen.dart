import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import './drawerWidget.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'filter_location.dart';

class HomeScreen extends StatefulWidget {
  BuildContext navContext;
  String add;
  HomeScreen({Key key, BuildContext navContext, String add}) {
    this.add = add;
    this.navContext = navContext;
  } //: super(key: key);

  void setAdd(String address) {
    this.add = address;
    HomeScreenState().rebuild();
  }

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isTyping = false;
  bool isSearching = false;
  List<String> photos = [
    'assets/airpods.jpg',
    'assets/dress.jpg',
    'assets/headphones.jpg',
    'assets/iphone.png',
    'assets/iphone11.jpg',
    'assets/laptop.jpg'
  ];

  TextEditingController _controller = TextEditingController();
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
      FirestoreService().searchByName(value).then((QuerySnapshot docs) {
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

  void rebuild() {
    setState(() {});
  }

  void _showAlertDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            content: Container(
              alignment: Alignment.center,
              child: Text(
                widget.add,
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
                    icon:
                        Icon(Icons.close, color: Colors.deepPurple, size: 30.0),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            backgroundColor: Colors.deepPurple[800],
            title: Text(
              "Porsio",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              widget.add == ''
                  ? Icon(Icons.location_off)
                  : IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _showAlertDialog(context);
                      },
                    ),
              // : ActionChip(
              //     backgroundColor: Colors.white,
              //     label: Text(
              //         widget.add.replaceAll(' ', '').substring(0, 15) +
              //             '...',
              //         style: TextStyle(color: Colors.deepPurple)),
              //     onPressed: () {
              //       _showAlertDialog(context);
              //     },
              //   ),
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
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: TextFormField(
                  onChanged: (value) {
                    checkTyping(value);
                    initiateSearch(value);
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
          isTyping
              ? (tempSearchStore.length == 0)
                  ? isSearching
                      ? SliverList(
                          delegate: SliverChildListDelegate(<Widget>[
                            Center(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: SpinKitCubeGrid(
                                        color: Colors.deepPurple)))
                          ]),
                        ) //
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
                              tempSearchStore[index].data['isFav'],
                              tempSearchStore[index].data['price'],
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
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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
                            onPressed: () {
                              //Navigator.of(widget.navContext).pushNamed('/filter_location', arguments: widget.add);
                              _awaitReturnValueFromFilter(
                                  widget.navContext, widget.add);
                            },
                            shape: StadiumBorder(),
                            splashColor: Colors.purple,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Filter",
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      //decoration: BoxDecoration(color: Colors.red),
                      child: StreamBuilder(
                          stream: FirestoreService().getStores(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Center(
                                  child: SpinKitChasingDots(
                                      color: Colors.deepPurple));
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot document =
                                    snapshot.data.documents[index];
                                String type = document['type'];
                                return InkWell(
                                  onTap: () {
                                    print(index);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 4, right: 4),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.pink[200],
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              13,
                                          padding: EdgeInsets.all(5.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Image.asset(
                                                'assets/typeIcons/$type.png'),
                                          ),
                                        ),
                                        Text(document.documentID,
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
                            onPressed: () {},
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12.0),
                            ),
                            shape: StadiumBorder(),
                            splashColor: Colors.purple,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200.0,
                      child: Carousel(
                        onImageTap: null,
                        boxFit: BoxFit.cover,
                        images: List.generate(photos.length, (index) {
                          return Image.asset(photos[index]);
                        }),
                        autoplay: true,
                        dotSize: 5.0,
                        dotColor: Colors.black,
                        dotIncreasedColor: Colors.purple,
                        dotBgColor: Colors.transparent,
                        indicatorBgPadding: 2.0,
                      ),
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
                            onPressed: () {},
                            shape: StadiumBorder(),
                            splashColor: Colors.purple,
                            child: Text(
                              "Explore",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      //height: MediaQuery.of(context).size.height * 10,
                      child: StreamBuilder(
                        stream: FirestoreService().getProducts(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: SpinKitChasingDots(
                                color: Colors.deepPurple,
                              ),
                            );
                          return Center(
                            child: Wrap(
                                runSpacing: 2,
                                spacing: 2,
                                children: List.generate(
                                    snapshot.data.documents.length, (index) {
                                  DocumentSnapshot document =
                                      snapshot.data.documents[index];
                                  return _singleProd("Index $index", document,
                                      widget.navContext);
                                })),
                          );
                        },
                      ),
                    ),
                  ],
                )),
        ],
      ),
    );
  }

  void _awaitReturnValueFromFilter(BuildContext context, String add) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterLocation(
          add: add,
        ),
      ),
    );
    if (result != null)
      setState(() {
        widget.add = result;
      });
  }

  Widget itemCard(String name, String imgPath, String description, bool isFav,
      String price,DocumentSnapshot document, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
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
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/description', arguments: document);
                    },
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
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        '/description',
                                        arguments: document);
                                  },
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
                                    elevation: isFav ? 2 : 0,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              (1 / 3) *
                                              (1 / 4),
                                      width: MediaQuery.of(context).size.width *
                                          (1 / 3) *
                                          (1 / 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                (1 / 3) *
                                                (1 / 8)),
                                        color: isFav
                                            ? Colors.white
                                            : Colors.grey.withOpacity(0.2),
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          icon: isFav
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
                                            FirestoreService().changeFav(
                                                document.documentID, isFav);
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
                              // 'Product description xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
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
                                flex: 10,
                                child: Material(
                                  elevation: 7,
                                  borderRadius: BorderRadius.circular(10),
                                  shadowColor: Colors.purple,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                    ),
                                    height: 40,
                                    // width: MediaQuery.of(context).size.width *
                                    //     (1 / 3) *
                                    //     (1.7 / 3),
                                    child: Center(
                                      child: Text(
                                        price,
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
                                flex: 16,
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
                                      width: MediaQuery.of(context).size.width *
                                          (1 / 3) *
                                          (2.7 / 3),
                                      child: Center(
                                        child: FlatButton(
                                          onPressed: () {
                                            FirestoreService().addToCart(
                                                document.documentID, 1, false);
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
    );
  }

  _singleProd(name, DocumentSnapshot document, BuildContext navContext) {
    return InkWell(
      onTap: () {
        Navigator.of(navContext).pushNamed('/description', arguments: document);
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.46,
          child: Material(
            elevation: 0,
            //color: Colors.grey,
            borderRadius: BorderRadius.circular(25),
            shadowColor: Colors.purple,
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.46,
                  height: MediaQuery.of(context).size.width * 0.46,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(document['catalogue']
                          [0]), //AssetImage("assets/images/LOGO2.png"),
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // FlatButton(
                    //     color: Colors.purple[700].withOpacity(.5),
                    //     child: Icon(
                    //       Icons.add_shopping_cart,
                    //       color: Colors.white,
                    //     ),
                    //     onPressed: () {},
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(30.0))),
                    IconButton(
                      icon: document['isFav']
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red.withOpacity(0.7),
                            )
                          : Icon(Icons.favorite_border,
                              color: Colors.grey[900].withOpacity(0.7)),
                      onPressed: () {
                        FirestoreService()
                            .changeFav(document.documentID, document['isFav']);
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
