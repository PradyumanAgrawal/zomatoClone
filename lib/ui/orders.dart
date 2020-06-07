import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
                    return Center(child: Text('No Orders'));
                  } else {
                    var orderList = snapshot.data.documents.toList();
                    return orderList.length == 0
                        ? Center(
                            child: Text('No Orders!',
                                style: TextStyle(fontSize: 20)),
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
                                            Column(
                                              children: [
                                                Container(
                                                  child: Text('Order ID'),
                                                ),
                                              ],
                                            ),
                                            Text(orderList[index].documentID),
                                          ]) /* Center(child:Text(orderList[index]['prodId']+ ' \u{20B9} ' + orderList[index]['amount'].toString())), */
                                      ),
                                  Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Text(orderList[index]
                                                        ['prodName'])),
                                              ],
                                            ),
                                            Text('Quantity: ' +
                                                orderList[index]['quantity']
                                                    .toString()),
                                          ]) /* Center(child:Text(orderList[index]['prodId']+ ' \u{20B9} ' + orderList[index]['amount'].toString())), */
                                      ),
                                  Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Total Amount:'),
                                            Text(' \u{20B9} ' +
                                                orderList[index]['amount']
                                                    .toString()),
                                          ]) /* Center(child:Text(orderList[index]['prodId']+ ' \u{20B9} ' + orderList[index]['amount'].toString())), */
                                      ),
                                  Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Status: '),
                                            Text(orderList[index]['status'])
                                          ]) /* Center(child:Text(orderList[index]['prodId']+ ' \u{20B9} ' + orderList[index]['amount'].toString())), */
                                      ),
                                ],
                              ));
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
