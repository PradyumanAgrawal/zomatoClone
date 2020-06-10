import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';

class Cart extends StatefulWidget {
  BuildContext navContext;
  Cart({Key key, this.navContext}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  double totalPrice = 0;
  String userId;
  bool buttonVisible = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalData().getUid(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          userId = snapshot.data;
          return StreamBuilder(
            stream: FirestoreService().getUser(userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Scaffold(
                  body: Center(
                      child: SpinKitChasingDots(
                    color: Colors.purple,
                  )),
                );
              DocumentSnapshot document = snapshot.data;
              if (document['cart'].isEmpty) {
                buttonVisible = false;
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    backgroundColor: Colors.deepPurple[800],
                    title: Text(
                      "My Cart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          height: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/emptyCart.png'),
                              //colorFilter: ColorFilter.mode(Colors.purple, BlendMode.color),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Add products in your cart to see them here...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              var productList = document['cart'].keys.toList();
              return StreamBuilder(
                stream: FirestoreService().getCartProducts(productList),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Scaffold(
                      body: Center(
                        child: SpinKitChasingDots(
                          color: Colors.purple,
                        ),
                      ),
                    );
                  totalPrice = 0;
                  for (int i = 0; i < snapshot.data.documents.length; i++,) {
                    DocumentSnapshot productDoc = snapshot.data.documents[i];
                    if(productList.contains(productDoc.documentID))
                    {
                      totalPrice += int.parse(productDoc['price']) *
                          (1 -
                              int.parse(productDoc['discount'] == null
                                      ? '0'
                                      : productDoc['discount']) /
                                  100) *
                          document['cart'][productDoc.documentID]['quantity'];
                    }
                  }
                  int listLength = snapshot.data.documents.length;
                  return Scaffold(
                    bottomSheet: Material(
                      elevation: 7.0,
                      color: Colors.white70,
                      child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //SizedBox(width: 10.0),
                              Flexible(
                                flex: 40,
                                child: Center(
                                  child: Text(
                                    '\u{20B9} ' +
                                        totalPrice.roundToDouble().toString(),
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 60,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurple[800],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  child: Center(
                                    child: FlatButton(
                                      onPressed: () async {
                                        if (userId != null) {
                                          Navigator.of(context).pushNamed(
                                              '/review_order',
                                              arguments: widget.navContext);
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Place Order',
                                            style: TextStyle(
                                                fontSize: 18.0,
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
                    body: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          leading: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          floating: true,
                          pinned: false,
                          snap: true,
                          backgroundColor: Colors.deepPurple[800],
                          title: Text(
                            "My Cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate(
                          <Widget>[
                            Column(
                              children: List<Widget>.generate(
                                listLength,
                                (index) {
                                  DocumentSnapshot productDoc =
                                      snapshot.data.documents[index];
                                  try {
                                    return product(
                                        widget.navContext,
                                        index,
                                        productDoc,
                                        document['cart'][productDoc.documentID]
                                            ['quantity'],
                                        document['cart'][productDoc.documentID]
                                            ['variant']);
                                  } catch (e) {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.09)
                          ],
                        )),
                      ],
                    ),
                  );
                },
              );
            },
          );
        } else {
          return Scaffold(
            body: Center(
              child: SpinKitChasingDots(
                color: Colors.purple,
              ),
            ),
          );
        }
      },
    );
  }

  product(context, index, DocumentSnapshot productDoc, int quantity,
      String variant) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: <Widget>[
          Material(
            elevation: 2,
            shadowColor: Colors.purple,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.purple[100]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [0.8, 1],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('/description',
                                  arguments: productDoc);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(productDoc['catalogue'][0]),
                                fit: BoxFit.contain,
                              ),
                            )),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  flex: 20,
                                  child: Container(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/description',
                                            arguments: productDoc);
                                      },
                                      child: Text(
                                        productDoc['name'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Visibility(
                                  visible: (variant != ''),
                                  child: Text(variant),
                                ),
                                Flexible(
                                  flex: 20,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: (productDoc['discount'] == null
                                                ? '0'
                                                : productDoc['discount']) !=
                                            '0'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '\u{20B9} ' +
                                                    '${int.parse(productDoc['price']) * quantity}',
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                  ' ' +
                                                      productDoc['discount'] +
                                                      "% off",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey)),
                                              Text(
                                                "  " +
                                                    '\u{20B9} ' +
                                                    '${(int.parse(productDoc['price']) * (1 - int.parse(productDoc['discount']) / 100) * quantity).roundToDouble()}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              )
                                            ],
                                          )
                                        : Text(
                                            '\u{20B9} ' +
                                                '${int.parse(productDoc['price']) * quantity}',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    /* Text(
                                      'Price: ' +
                                          '\u{20B9}' +
                                          (int.parse(productDoc['price']) *
                                                  quantity)
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.deepPurple[900]),
                                    ), */
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Quantity :",
                            style:
                                TextStyle(fontSize: 15, color: Colors.black)),
                        IconButton(
                            icon: (quantity > 1)
                                ? Icon(Icons.remove, color: Colors.red)
                                : Icon(
                                    Icons.fiber_manual_record,
                                    color: Colors.white,
                                    size: 0,
                                  ),
                            onPressed: () {
                              if (quantity > 1) {
                                int newQuantity = quantity - 1;
                                FirestoreService().addToCart(
                                    productDoc.documentID,
                                    newQuantity,
                                    variant,
                                    true);
                              }
                            }),
                        Text(
                          '$quantity',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            icon: Icon(Icons.add, color: Colors.green),
                            onPressed: () {
                              int newQuantity = quantity + 1;
                              FirestoreService().addToCart(
                                  productDoc.documentID,
                                  newQuantity,
                                  variant,
                                  true);
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.height / 15,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    FirestoreService()
                        .addToCart(productDoc.documentID, 0, variant, true)
                        .then((value) {});
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
        overflow: Overflow.visible,
      ),
    );
  }
}
