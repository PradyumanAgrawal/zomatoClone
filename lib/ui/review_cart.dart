import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';

class ReviewCart extends StatefulWidget {
  BuildContext navContext;
  ReviewCart({Key key, this.navContext}) : super(key: key);
  @override
  _ReviewCartState createState() => _ReviewCartState();
}

class _ReviewCartState extends State<ReviewCart> {
  int selectedAdd = 0;

  Future<void> detailsIncomplete(context) {
    return showDialog(
        context: context,
        builder: (dContext) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Container(
                child: Text('Please complete delivery details.'),
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(dContext).pop();
                    }),
              ]);
        });
  }

  Future<void> newMobileNo(context) {
    return showDialog(
        context: context,
        builder: (dContext) {
          String newAdd = '';
          return AlertDialog(
              content: TextFormField(
                keyboardType: TextInputType.number,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "New Mobile Number",
                  fillColor: Colors.grey,
                  focusColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onChanged: (value) {
                  newAdd = value;
                },
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(
                child: Text('New Mobile Number'),
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(dContext).pop();
                    }),
                FlatButton(
                    child: Text('Save'),
                    onPressed: () async {
                      print(newAdd);
                      if (newAdd != '') {
                        await FirestoreService().addMobile(newAdd);
                        Navigator.of(dContext).pop();
                      }
                    }),
              ]);
        });
  }

  Future<void> newAddress(context) {
    return showDialog(
        context: context,
        builder: (dContext) {
          String newAdd = '';
          return AlertDialog(
              content: TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "New Address",
                  fillColor: Colors.grey,
                  focusColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onChanged: (value) {
                  newAdd = value;
                },
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(
                child: Text('New Address'),
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(dContext).pop();
                    }),
                FlatButton(
                    child: Text('Save'),
                    onPressed: () async {
                      print(newAdd);
                      if (newAdd != '') {
                        await FirestoreService().addAddress(newAdd);
                        Navigator.of(dContext).pop();
                      }
                    }),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Order'),
        backgroundColor: Colors.deepPurple[800],
      ),
      body: FutureBuilder(
        future: FirestoreService().reviewCart(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'empty') {
              return Center(child: Text("Empty Cart"));
            }
            return ListView(
              children: [
                Card(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Total Price',
                              style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                              '\u{20B9} ' + snapshot.data['total'].toString(),
                              style: TextStyle(fontSize: 15)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Total Items',
                              style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(snapshot.data['itemCount'].toString(),
                              style: TextStyle(fontSize: 15)),
                        )
                      ],
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Delivery Details',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Card(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Phone Number'),
                        ),
                      ],
                    ),
                    snapshot.data['mobileNo'] == ''
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlineButton(
                                onPressed: () {
                                  newMobileNo(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.add),
                                    Text('New Mobile Number')
                                  ],
                                )),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshot.data['mobileNo']),
                              ),
                              IconButton(
                                onPressed: () {
                                  newMobileNo(context);
                                },
                                icon: Icon(Icons.edit),
                              )
                            ],
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Address'),
                        ),
                      ],
                    ),
                    snapshot.data['address'].length == 0
                        ? Container()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List<Widget>.generate(
                                snapshot.data['address'].length, (index) {
                              return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedAdd = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              color: index == selectedAdd
                                                  ? Colors.deepPurple[100]
                                                  : Colors.white,
                                            ),
                                            alignment: Alignment.centerLeft,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Text(
                                              snapshot.data['address'][index],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black),
                                            )),
                                      ],
                                    ),
                                  ));
                            })),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                          onPressed: () {
                            newAddress(context);
                          },
                          child: Row(
                            children: [Icon(Icons.add), Text('New Address')],
                          )),
                    ),
                    SizedBox(height: 15)
                  ],
                )),
                Material(
                  elevation: 7.0,
                  color: Colors.white70,
                  child: Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[800],
                              ),
                              child: Center(
                                child: FlatButton(
                                  onPressed: () async {
                                    if (snapshot.data['address'].length == 0 ||
                                        snapshot.data['mobileNo'] == '') {
                                      return detailsIncomplete(context);
                                    } else {
                                      await FirestoreService().placeOrder(
                                          snapshot.data['address'][selectedAdd],
                                          snapshot.data['mobileNo']);
                                      Navigator.of(widget.navContext).pop();
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  /* onPressed: () async {
                      await FirestoreService().placeOrder();
                      Navigator.of(widget.navContext).pop();
                      Navigator.of(context).pop();
                    }, */
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Confirm Order',
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
              ],
            );
          } else {
            return Center(
                child: SpinKitChasingDots(
              color: Colors.deepPurple[900],
            ));
          }
        },
      ),
    );
  }
}
