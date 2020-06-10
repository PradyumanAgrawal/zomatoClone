import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Discover extends StatefulWidget {
  BuildContext navContext;
  Discover({BuildContext navContext}) {
    this.navContext = navContext;
  }
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  //var productList = new List<Product>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.deepPurple[800],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.menu),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Material(
                        elevation: 5.0,
                        shadowColor: Colors.purple,
                        borderRadius: BorderRadius.circular(5),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.purple,
                                size: 30,
                              ),
                              contentPadding:
                                  EdgeInsets.only(left: 15, top: 15),
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              )),
                        )),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Stack(
            children: <Widget>[
              Material(
                elevation: 2,
                child: Container(
                  height: 50,
                  color: Colors.white70,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 5),
                        child: FlatButton(
                          onPressed: () {},
                          child: Text("Filter"),
                          textColor: Colors.grey,
                        )),
                  ),
                  VerticalDivider(
                    color: Colors.grey,
                    width: 1,
                    thickness: 2,
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 5),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(widget.navContext)
                                .pushNamed('/description');
                          },
                          child: Text("Sort"),
                          textColor: Colors.grey,
                        )),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 1000,
            child: StreamBuilder(
              stream: Firestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data.documents[index];
                    return itemCard(
                        document['name'],
                        document['catalogue'][0],
                        document['isFav'],
                        document['price'],
                        widget.navContext);
                  },
                );
              },
            ),
          ),
          // itemCard('iPhone 11','assets/iphone11.jpg', true,'86000', widget.navContext),
          // SizedBox(height:10),
          // itemCard('Headphones','assets/headphones.jpg', !true,'20000',widget.navContext),
          // SizedBox(height:10),
          // itemCard('Laptop','assets/laptop.jpg', true,'150000',widget.navContext),
          // SizedBox(height:10),
          // itemCard('iPhone 11','assets/airpods.jpg', !true,'15000',widget.navContext),
          // SizedBox(height:10),
          // itemCard('Dress','assets/dress.jpg', true,'5000',widget.navContext),
          // SizedBox(height:10),
        ],
      ),
    );
  }
}

Widget itemCard(String name, String imgPath, bool isFav, String price,
    BuildContext context) {
  return Material(
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
              child: Container(
                height: 150.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(imgPath), fit: BoxFit.contain)),
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
                            flex: 8,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/description');
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
                          Flexible(
                            flex: 2,
                            child: Container(
                              child: Material(
                                elevation: isFav ? 2 : 0,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: MediaQuery.of(context).size.width *
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
                                      iconSize:
                                          MediaQuery.of(context).size.width *
                                                  (1 / 3) *
                                                  (1 / 8) -
                                              1,
                                      onPressed: () {
                                        //itemCard(name, imgPath, !isFav); //TODO figure out how to use the button
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
                          'Product description xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
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
                          Flexible(
                            flex: 1,
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
                                width: MediaQuery.of(context).size.width *
                                    (1 / 3) *
                                    (1.7 / 3),
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
                            flex: 2,
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
                                    onPressed: () {},
                                    child: Text(
                                      'Add To Cart',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
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
  );
}
