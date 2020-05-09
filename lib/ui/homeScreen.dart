import 'package:flutter/material.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import './drawerWidget.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> photos = [
    'assets/airpods.jpg',
    'assets/dress.jpg',
    'assets/headphones.jpg',
    'assets/iphone.png',
    'assets/iphone11.jpg',
    'assets/laptop.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  decoration: InputDecoration(
                    hintText: "Search",
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.search,
                     color: Colors.purple),
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
          SliverList(
              delegate: SliverChildListDelegate(
            <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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
                      onPressed: () {},
                      shape: StadiumBorder(),
                      splashColor: Colors.purple,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Filter",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12.0),
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
                    stream:  FirestoreService().getStores(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading...');
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = snapshot.data.documents[index];
                          String type = document['type'];
                          return InkWell(
                            onTap: () {
                              print(index);
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 4, right: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration : BoxDecoration(
                                       shape : BoxShape.circle,
                                       color : Colors.pink[200],
                                    ),
                                   
                                    width: MediaQuery.of(context).size.height/13,
                                    padding: EdgeInsets.all(5.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset('assets/typeIcons/$type.png'),
                                    ),
                                  ),
                                  Text( document.documentID,
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
              Column(
                children: List.generate(7, (index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _singleProd("Index $index"),
                        _singleProd("Index $index"),
                      ],
                    ),
                  );
                }),
              ),
            ],
          )),
        ],
      ),
    );
  }

  _singleProd(name) {
    return InkWell(
      onTap: () {},
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.48,
            height: MediaQuery.of(context).size.width * 0.48,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/LOGO2.png"),
                  fit: BoxFit.cover),
            ),
          ),
          Row(
            children: <Widget>[
              FlatButton(
                  color: Colors.purple[700].withOpacity(.5),
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.red.withOpacity(0.5)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
