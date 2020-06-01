import 'package:cloud_firestore/cloud_firestore.dart';
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
      appBar: AppBar(
          backgroundColor: Colors.deepPurple[800], title: Text('Orders')),
      body: FutureBuilder(
        future: LocalData().getUid(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            var uid = snapshot.data;
            return StreamBuilder(
              stream: FirestoreService().getOrders(uid) ,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  var orderList = snapshot.data.documents.toList();
                  return ListView.builder(itemCount:orderList.length,
                  itemBuilder: (context, index) {
                    return Card(child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children:[
                              Text(orderList[index]['prodName']),
                              Text('Quantity: '+ orderList[index]['quantity'].toString()),
                            ]
                          )/* Center(child:Text(orderList[index]['prodId']+ ' \u{20B9} ' + orderList[index]['amount'].toString())), */
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children:[
                              Text('Total Amount:'),
                              Text(' \u{20B9} ' + orderList[index]['amount'].toString()),
                            ]
                          )/* Center(child:Text(orderList[index]['prodId']+ ' \u{20B9} ' + orderList[index]['amount'].toString())), */
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children:[
                              Text('Status: '),
                              Text(orderList[index]['status'])
                            ]
                          )/* Center(child:Text(orderList[index]['prodId']+ ' \u{20B9} ' + orderList[index]['amount'].toString())), */
                        ),
                      ],
                    ));
                  },);
                }
              },
            );
          }
          else{
            return Center(child: SpinKitChasingDots(color:Colors.deepPurple[900]),);
          }
        },
      ),
    );
  }
}
