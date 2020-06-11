import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../functionalities/firestore_service.dart';
import '../functionalities/local_data.dart';
import 'drawerWidget.dart';

class Orders extends StatefulWidget {
  BuildContext navContext;
  Orders({BuildContext navContext}) {
    this.navContext = navContext;
  }
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(navContext: widget.navContext),
      appBar: AppBar(actions: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(widget.navContext)
                .pushNamed('/cart', arguments: widget.navContext);
          },
        ),
      ], backgroundColor: Colors.deepPurple[800], title: Text('Orders')),
      body: FutureBuilder(
        future: LocalData().getUid(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var uid = snapshot.data;
            return StreamBuilder(
              stream: FirestoreService().getOrders(uid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == {}) {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Icon(LineAwesomeIcons.shopping_basket),
                          Text(
                            'No orders yet!',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    var orderList = snapshot.data.documents.toList();
                    return orderList.length == 0
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(LineAwesomeIcons.shopping_basket,
                                      color: Colors.grey, size: 30),
                                ),
                                Text(
                                  'No orders yet!',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: orderList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Order ID:',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          Text(orderList[index].documentID),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  orderList[index]['image'],
                                                ),
                                                fit: BoxFit.contain),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                orderList[index]['prodName'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Visibility(
                                                visible: (orderList[index]
                                                        ['variant'] !=
                                                    ''),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Text(orderList[index]
                                                      ['variant']),
                                                ),
                                              ),
                                              Text(
                                                'Quantity : ' +
                                                    orderList[index]['quantity']
                                                        .toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20,
                                          bottom: 15,
                                          left: 40,
                                          right: 40),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Order Placed:',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                          Text(
                                            orderList[index]['timeStamp']
                                                .toDate()
                                                .toString()
                                                .substring(0, 10),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15,
                                            bottom: 15,
                                            left: 40,
                                            right: 40),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Total Amount:',
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                              Text(
                                                ' \u{20B9} ' +
                                                    orderList[index]['amount']
                                                        .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ]) /* Center(child:Text(orderList[index]['prodId']+ ' \u{20B9} ' + orderList[index]['amount'].toString())), */
                                        ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15,
                                          bottom: 20,
                                          left: 40,
                                          right: 40),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Status: ',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            orderList[index]['status'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: (orderList[index]
                                                          ['status'] ==
                                                      'pending')
                                                  ? Colors.blue
                                                  : (orderList[index]
                                                              ['status'] ==
                                                          'Rejected')
                                                      ? Colors.red
                                                      : (orderList[index]
                                                                  ['status'] ==
                                                              'Accepted')
                                                          ? Colors.green
                                                          : Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                  }
                } else {
                  return Center(
                    child: SpinKitChasingDots(color: Colors.deepPurple[900]),
                  );
                }
              },
            );
          } else {
            return Center(
              child: SpinKitChasingDots(color: Colors.deepPurple[900]),
            );
          }
        },
      ),
    );
  }
}
