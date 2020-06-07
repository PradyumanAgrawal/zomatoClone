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
    final GlobalKey<FormState> _fKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (dContext) {
          String newAdd = '';
          return AlertDialog(
              content: Form(
                key: _fKey,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty || value.length != 10) {
                      return 'Please Enter 10-digit Number';
                    }
                  },
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
                      if (_fKey.currentState.validate()) {
                        print(newAdd);
                        if (newAdd != '') {
                          await FirestoreService().addMobile(newAdd);
                          Navigator.of(dContext).pop();
                        }
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
                        : Wrap(
                            children: List<Widget>.generate(
                                snapshot.data['address'].length, (index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedAdd = index;
                                });
                              },
                              child: Card(
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  color: index == selectedAdd
                                      ? Colors.deepPurple[100]
                                      : Colors.white,
                                  width: 150,
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data['address'][index]
                                              ['name'],
                                          // 'Name',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          snapshot.data['address'][index]
                                              ['line1'],
                                          //'Address Line xxxxxxxx 1',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          snapshot.data['address'][index]
                                              ['line2'],
                                          //'AddressLine2',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          snapshot.data['address'][index]
                                              ['city'],
                                          //'City',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          snapshot.data['address'][index]
                                              ['state'],
                                          //'State',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          snapshot.data['address'][index]
                                              ['pincode'],
                                          //'Pincode',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.call, size: 10),
                                            SizedBox(width: 10),
                                            Text(
                                              snapshot.data['address'][index]
                                                  ['phone'],
                                              //'xxxxxxxxxx',
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                          onPressed: () {
                            /* newAddress(context); */
                            var sheetController = showBottomSheet(
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                context: context,
                                builder: (context) => AddSheet());
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

class AddSheet extends StatefulWidget {
  @override
  _AddSheetState createState() => _AddSheetState();
}

class _AddSheetState extends State<AddSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Map newAdd = new Map();
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height * 0.9,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Name';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Name",
                    labelText: "Name",
                    fillColor: Colors.grey,
                    focusColor: Colors.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  onSaved: (value) {
                    newAdd['name'] = value;
                  },
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Address Line 1';
                  }
                },
                minLines: null,
                decoration: InputDecoration(
                  hintText: "Flat, House no., Building, Company, Apartment",
                  labelText: "Address Line 1",
                  fillColor: Colors.grey,
                  focusColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onSaved: (value) {
                  newAdd['line1'] = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Address Line 2';
                  }
                },
                minLines: null,
                decoration: InputDecoration(
                  hintText: "Area, Colony, Street, Sector, Village",
                  labelText: "Address Line 2",
                  fillColor: Colors.grey,
                  focusColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onSaved: (value) {
                  newAdd['line2'] = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter City';
                  }
                },
                decoration: InputDecoration(
                  hintText: "Town/City",
                  labelText: "city",
                  fillColor: Colors.grey,
                  focusColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onSaved: (value) {
                  newAdd['city'] = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter State';
                  }
                },
                decoration: InputDecoration(
                  hintText: "State / Province / Region",
                  labelText: "State",
                  fillColor: Colors.grey,
                  focusColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onSaved: (value) {
                  newAdd['state'] = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty || value.length != 6) {
                    return 'Please Enter valid Pincode';
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "6 digits [0-9] PIN code",
                  labelText: "PIN code",
                  fillColor: Colors.grey,
                  focusColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onSaved: (value) {
                  newAdd['pincode'] = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty || value.length != 10) {
                    return 'Please Enter 10-digit Number';
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "10-digit number without any prefixes",
                  labelText: "Mobile Number",
                  fillColor: Colors.grey,
                  focusColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onSaved: (value) {
                  newAdd['phone'] = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionChip(
                          backgroundColor: Colors.deepPurple,
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Cancel',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      ActionChip(
                          backgroundColor: Colors.deepPurple,
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Save',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              FirestoreService().addAddress(newAdd);
                              Navigator.of(context).pop();
                            }
                          }),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
