import 'package:flutter/material.dart';
import 'package:my_flutter_app/drawerWidget.dart';

class Cart extends StatefulWidget {
  Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var q = <int> [1,2,3,4];
  void add(index){
    setState(() {
      q[index]+=1;
    });
  }
  void subtract(index){
    if(q[index]>=1){
    setState(() {
      q[index]-=1;
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      drawer: DrawerWidget(),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        height: MediaQuery.of(context).size.height * 0.08,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Rs. x,xxx",
              style: TextStyle(
                  color: Colors.deepPurple[900],
                  fontSize: 25.0,
                  fontWeight: FontWeight.normal),
            ),
            RaisedButton(
                elevation: 10.0,
                color: Colors.deepPurple[900],
                child: Text(
                  "        Place Order        ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.normal),
                ),
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            backgroundColor: Colors.deepPurple[700],
            title: Text(
              "My Cart",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                SizedBox(
                  height: 4.0,
                ),
                _product(context, 0),
                _product(context, 1),
                _product(context, 2),
                _product(context, 3),
                SizedBox(height: MediaQuery.of(context).size.height * 0.09)
              ],
            ),
          ),
        ],
      ),
    );
  }

  _product(context,index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 20.0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.28,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(4.0),
                      width: MediaQuery.of(context).size.height * 0.2,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/iphone.png")),
                      ),
                    ),
                    Text(
                      "Product Name",
                      style: TextStyle(
                          fontSize: 20, color: Colors.deepPurple[900]),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Price: Rs. x,xxx",
                      style:
                          TextStyle(fontSize: 20, color: Colors.deepPurple[900]),
                    ),
                    Text(
                      "This is Product description\nThis is Product description",
                      style:
                          TextStyle(fontSize: 12, color: Colors.deepPurple[900]),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Quantity ", style:
                          TextStyle(fontSize: 15, color: Colors.deepPurple[900])),
                  IconButton(icon: (q[index]>1)? Icon(Icons.remove, color: Colors.red) : Icon(Icons.delete, color: Colors.red,), onPressed:(){subtract(index);} ),
                  Text("${q[index]}", style: TextStyle(fontWeight:FontWeight.bold),),
                  IconButton(icon: Icon(Icons.add, color: Colors.green), onPressed: (){add(index);}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
