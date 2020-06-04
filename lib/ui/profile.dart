import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DocumentSnapshot userDoc;
  String name;
  String email;
  String phone;
  File profilePic = null;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        tooltip: 'Edit Profile',
        label: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.deepPurple[800],
          ),
        ),
        icon: Icon(Icons.edit, color: Colors.deepPurple[800]),
        onPressed: () {
          profilePic = null;
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Center(
                    child: Text(
                      'Edit Profile',
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    FlatButton(
                      child: Text('Save'),
                      onPressed: () async {
                        bool condition = name != null &&
                            email != null &&
                            phone != null &&
                            name != '' &&
                            email != '' &&
                            phone != '';
                        if (condition) {
                          bool status = await FirestoreService()
                              .editProfile(name, email, phone, userDoc,profilePic);
                          if (status) {
                            // Scaffold.of(context).showSnackBar(SnackBar(
                            //   content: Text('Updated!!'),
                            // ));
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    ),
                  ],
                  contentPadding: EdgeInsets.all(0),
                  content: Container(
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 30),
                        Center(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: (profilePic != null)
                                        ? FileImage(profilePic)
                                        : NetworkImage(
                                            userDoc['displayPic'],
                                          ),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    color: Colors.deepPurple[900],
                                    icon: Icon(Icons.edit, size: 15),
                                    onPressed: () async {
                                      final tempImage = await picker.getImage(
                                          source: ImageSource.gallery);
                                      setState(() {
                                        profilePic = File(tempImage.path);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Name",
                              labelText: "Name",
                              fillColor: Colors.grey,
                              focusColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                            onChanged: (value) {
                              name = value;
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            initialValue: email,
                            decoration: InputDecoration(
                              hintText: "Email",
                              labelText: "Email",
                              fillColor: Colors.grey,
                              focusColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            initialValue: phone,
                            decoration: InputDecoration(
                              hintText: "Contact",
                              labelText: "Contact",
                              fillColor: Colors.grey,
                              focusColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                            onChanged: (value) {
                              phone = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          );
        },
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            backgroundColor: Colors.deepPurple[800],
            title: Text(
              "Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () {},
              )
            ],
            shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(10),
                //   bottomRight: Radius.circular(10),
                // ),
                ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                FutureBuilder(
                  future: LocalData().getUid(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                          child: SpinKitChasingDots(
                        color: Colors.purple,
                      ));
                    String userId = snapshot.data;
                    return StreamBuilder(
                      stream: FirestoreService().getUser(userId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: SpinKitChasingDots(
                              color: Colors.purple,
                            ),
                          );
                        userDoc = snapshot.data;
                        name = userDoc['name'];
                        email = userDoc['email'];
                        phone = userDoc['mobileNo'];
                        return Column(
                          children: <Widget>[
                            Stack(
                              overflow: Overflow.visible,
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(userDoc['displayPic']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: BackdropFilter(
                                      filter: new ImageFilter.blur(
                                          sigmaX: 10.0, sigmaY: 0.0),
                                      child: Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.deepPurple
                                                .withOpacity(0.2)),
                                      )),
                                ),
                                Positioned(
                                  bottom: -5,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              6,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          )),
                                      Positioned(
                                        top:
                                            -MediaQuery.of(context).size.width /
                                                6,
                                        //right: MediaQuery.of(context).size.width/2 + MediaQuery.of(context).size.width/6,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                userDoc['displayPic'],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black,
                                                offset:
                                                    Offset(0.0, 1.0), //(x,y)
                                                blurRadius: 6.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: MediaQuery.of(context).size.width /
                                                6 +
                                            5,
                                        child: Text(
                                          userDoc['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Flexible(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Wishlist Items',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                          userDoc['wishlist'].length.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ))
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Cart Items',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(height: 5),
                                      Text(userDoc['cart'].length.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ))
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Profile',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(height: 5),
                                      userDoc['isProfileComplete']?Icon(Icons.done, color: Colors.green,):Icon(Icons.cancel, color: Colors.red,),
                                      /* Text('50%',
                                          style: TextStyle(
                                            color: userDoc['isProfileComplete']
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          )) */
                                    ],
                                  ),
                                ),
                                //VerticalDivider(),
                              ],
                            ),
                            Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      'UserID',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      userDoc.documentID,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      'Email',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      userDoc['email'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      'Contact info',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      userDoc['mobileNo'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      'Addresses',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Flexible(
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: 150.0,
                                  child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: userDoc['address'].length + 2,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0)
                                        return SizedBox(
                                          width: 30,
                                        );
                                      else if (index ==
                                          userDoc['address'].length + 1)
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (dContext) {
                                                  String newAdd = '';
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    title: Center(
                                                      child:
                                                          Text('New Address'),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          child: Text('Cancel'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    dContext)
                                                                .pop();
                                                          }),
                                                      FlatButton(
                                                          child: Text('Save'),
                                                          onPressed: () async {
                                                            if (newAdd != '')
                                                              FirestoreService()
                                                                  .newAddress(
                                                                      newAdd,
                                                                      userDoc);

                                                            Navigator.of(
                                                                    dContext)
                                                                .pop();
                                                          }),
                                                    ],
                                                    content: TextFormField(
                                                      minLines: null,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "New Address",
                                                        labelText:
                                                            "New Address",
                                                        fillColor: Colors.grey,
                                                        focusColor: Colors.grey,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .transparent),
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        newAdd = value;
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              width: 100,
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Center(
                                                  child: Icon(Icons.add_box)),
                                            ),
                                          ),
                                        );
                                      return Stack(
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (dContext) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    content: Center(
                                                      child: Text(
                                                        userDoc['address']
                                                            [index - 1],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: Container(
                                                width: 100,
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Center(
                                                  child: Text(
                                                    userDoc['address']
                                                        [index - 1],
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: -10,
                                            top: -10,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                FirestoreService()
                                                    .removeAddress(
                                                        index - 1, userDoc);
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Divider(),
                              ],
                            ),
                            // Expanded(
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemBuilder: (context, index) {},
                            //   ),
                            // ),
                            // Card(
                            //   child:Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Text('card'),
                            //   )
                            // ),
                            SizedBox(height: 80),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
