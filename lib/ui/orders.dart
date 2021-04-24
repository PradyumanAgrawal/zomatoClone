import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/orderItem.dart';
import 'package:my_flutter_app/models/productModel.dart';
import 'package:my_flutter_app/models/userModel.dart';
import 'package:provider/provider.dart';
import 'drawerWidget.dart';

class Orders extends StatefulWidget {
  final BuildContext navContext;
  Orders({this.navContext});
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  User userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<User>(context);
    return Scaffold(
      drawer: DrawerWidget(navContext: widget.navContext),
      appBar: AppBar(actions: [
        Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 10.0),
            child: InkWell(
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(widget.navContext)
                    .pushNamed('/cart', arguments: context);
              },
            )),
      ], backgroundColor: Colors.deepPurple[800], title: Text('Orders')),
      body: (userProvider == null)
          ? Center(
              child: SpinKitChasingDots(color: Colors.deepPurple),
            )
          : FutureBuilder(
              future: DBProvider.db.getOrders(userProvider.userId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == {}) {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/images/emptyOrders.png'),
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
                    List<OrderItem> orderList = snapshot.data;
                    return orderList.length == 0
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Image.asset(
                                        'assets/images/emptyOrders.png'),
                                    Text(
                                      'No orders yet!',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: orderList.length,
                            itemBuilder: (context, index) {
                              if (orderList[index] == null) return Container();
                              Product product = orderList[index].product;
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
                                          Text(index.toString()),
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
                                                  product.image,
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
                                                product.pName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                'Quantity : ' +
                                                    orderList[index]
                                                        .quantity
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
                                            (orderList[index].date == null)
                                                ? ''
                                                : orderList[index].date,
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
                                                (orderList[index].bill != null)
                                                    ? ' \u{20B9} ' +
                                                        orderList[index]
                                                            .bill
                                                            .toString()
                                                    : '',
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
                                            orderList[index].status,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: (orderList[index].status ==
                                                      'order placed')
                                                  ? Colors.blue
                                                  : (orderList[index].status ==
                                                          'Rejected')
                                                      ? Colors.red
                                                      : (orderList[index]
                                                                  .status ==
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
            ),
    );
  }
}
