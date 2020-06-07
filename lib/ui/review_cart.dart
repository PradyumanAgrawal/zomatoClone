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
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Products Details',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Column(
                        children: List.generate(
                            snapshot.data['products'].length, (index) {
                          List<Map> products = snapshot.data['products'];
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 5),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "\u2022 ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.width / 6,
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            products[index]['image'],
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Text(
                                    products[index]['name'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  'X',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  products[index]['quantity'].toString(),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Total Price',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
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
                            child: Text(
                              'Total Items',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(snapshot.data['itemCount'].toString(),
                                style: TextStyle(fontSize: 15)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
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
                            child: Text(
                              'Phone Number',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
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
                            child: Text(
                              'Shipping Address',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      snapshot.data['address'].length == 0
                          ? Container()
                          : Container(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data['address'].length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, left: 5),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedAdd = index;
                                        });
                                      },
                                      child: Card(
                                        clipBehavior: Clip.hardEdge,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
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
                                                  snapshot.data['address']
                                                      [index]['name'],
                                                  // 'Name',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  snapshot.data['address']
                                                      [index]['line1'],
                                                  //'Address Line xxxxxxxx 1',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  snapshot.data['address']
                                                      [index]['line2'],
                                                  //'AddressLine2',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  snapshot.data['address']
                                                      [index]['city'],
                                                  //'City',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  snapshot.data['address']
                                                      [index]['state'],
                                                  //'State',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  snapshot.data['address']
                                                      [index]['pincode'],
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
                                                      snapshot.data['address']
                                                          [index]['phone'],
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
                                    ),
                                  );
                                },
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          splashColor: Colors.grey,
                          onTap: () {
                            var sheetController = showBottomSheet(
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                context: context,
                                builder: (context) => AddSheet());
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple,
                                    offset: Offset(0.0, 2.0), //(x,y)
                                    blurRadius: 2.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.add),
                                    Text(
                                      'New Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Payment Details',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          '- Cash On Delivery',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        elevation: 10,
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Checkout',
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
                SizedBox(height: 40),
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
        height: MediaQuery.of(context).size.height,
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
                              setState(() {
                                _formKey.currentState.save();
                                FirestoreService().addAddress(newAdd);
                              });

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
