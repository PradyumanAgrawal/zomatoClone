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
      body: ListView(
        children: <Widget>[
          _top(),
          SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Super Offers",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                Text(
                  "View All",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                Text(
                  "Explore",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
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

  _top() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple[800],
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Text(
                    "Porsio",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: null),
            ],
          ),
          SizedBox(height: 20.0),
          TextField(
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
        ],
      ),
    );
  }
}
