import 'package:flutter/material.dart';
import './drawerWidget.dart';
import 'package:carousel_pro/carousel_pro.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  onPressed: null)
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
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
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
              SizedBox(height: 5.0),
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
                    Text(
                      "View All",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0),
                    ),
                  ],
                ),
              ),
              Container(
                height: 200.0,
                child: Carousel(
                  boxFit: BoxFit.cover,
                  images: [
                    Image.asset("assets/images/LOGO2.png"),
                    Image.asset("assets/images/LOGO2.png"),
                    Image.asset("assets/images/LOGO2.png"),
                    Image.asset("assets/images/LOGO2.png"),
                    Image.asset("assets/images/LOGO2.png"),
                  ],
                  autoplay: true,
                  dotSize: 5.0,
                  dotColor: Colors.black,
                  dotIncreasedColor: Colors.red,
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
                    Text(
                      "Explore",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                child: Row(
                  children: <Widget>[
                    _singleProd("item 1"),
                    _singleProd("item 2"),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    _singleProd("item 1"),
                    _singleProd("item 2"),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    _singleProd("item 1"),
                    _singleProd("item 2"),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    _singleProd("item 1"),
                    _singleProd("item 2"),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    _singleProd("item 1"),
                    _singleProd("item 2"),
                  ],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  _singleProd(name) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            width: 170.0,
            height: 170.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/LOGO2.png"),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        Text(name),
      ],
    );
  }
}
