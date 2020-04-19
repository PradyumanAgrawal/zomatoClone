import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class Discover extends StatefulWidget {
    @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
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
                color: Colors.deepPurple[300],
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
                  SizedBox(height: 25,),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(5),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search ,
                            color: Colors.purple[300],
                            size: 30,
                          ),
                          contentPadding: EdgeInsets.only(left: 15,top: 15),
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          )
                        ),
                      )
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 20,),
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
                          onPressed: () {} ,
                          child: Text("Filter"),
                          textColor: Colors.grey,
                        )
                    ),
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
                          onPressed: () {} ,
                          child: Text("Sort"),
                          textColor: Colors.grey,
                        )
                    ),
                  ),
                ],
              ),
            ],
          ),
          itemCard('iPhone 11','assets/iphone11.jpg', true,'86000'),
          itemCard('Headphones','assets/headphones.jpg', !true,'20000'),
          itemCard('Laptop','assets/laptop.jpg', true,'150000'),
          itemCard('iPhone 11','assets/airpods.jpg', !true,'15000'),
          itemCard('Dress','assets/dress.jpg', true,'5000'),
          Container(
          )
        ],
      ),
    );
  }
}

Widget itemCard (String name, String imgPath, bool isFav, String price){
  return Material(
    elevation: 1,
    borderRadius: BorderRadius.circular(5),
    child: Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Container( //card
        height: 180,
        width: double.infinity,
        color: Colors.white70,
        child: Row(
          children: <Widget>[
            Container(
              width: 140.0,
              height: 150.0,
              decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(imgPath), fit: BoxFit.contain)),
            ),
            SizedBox(width: 4.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 90,
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(width: 115),
                    Material(
                      elevation: isFav ? 2 : 0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: isFav ? Colors.white : Colors.grey.withOpacity(0.2),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: isFav ? Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_border),
                            iconSize: 16,
                            onPressed: () {
                              //itemCard(name, imgPath, !isFav); //TODO figure out how to use the button
                            } ,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  width: 175,
                  child: Text(
                      'Product description xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 87,),
                    Container(
                      height: 40,
                      width: 50,
                      color: Colors.purple,
                      child: Center(
                        child: Text(
                          price,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 100,
                      color: Colors.purple[300],
                      child: Center(
                        child: FlatButton(
                          onPressed: () {},
                          child: Text(
                            'Add To Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                            ),
                          ),
                        ),
                      )
                    )
                  ],
                )
              ],
            )
          ]
        ),
      ),
    ),
  );
}