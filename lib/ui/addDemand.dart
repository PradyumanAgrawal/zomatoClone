import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';

class AddDemand extends StatefulWidget {
  @override
  _AddDemandState createState() => _AddDemandState();
}

class _AddDemandState extends State<AddDemand> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  int catVal = 0;
  int subCatVal = 0;
  String details;
  bool vis = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[700],
        title: Text(
          'I want...',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Select Category', style: TextStyle(fontSize: 18)),
          ),
          StreamBuilder(
            stream: FirestoreService().getCategories(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: SpinKitChasingDots(
                    color: Colors.purple,
                  ),
                );
              var cats = <String>[];
              snapshot.data.documents.forEach((doc) {
                cats.add(doc.documentID.toString());
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: List<Widget>.generate(cats.length, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              catVal = index;
                              subCatVal = 0;
                              // print(snapshot.data.documents[index]
                              //     ['subCategories']);
                            });
                          },
                          child: Card(
                            color: index == catVal
                                ? Colors.deepPurple[700]
                                : Colors.white,
                            child: Container(
                                height: 90,
                                width: 90,
                                child: Center(
                                    child: Text(
                                  cats[index],
                                  style: TextStyle(
                                    color: index != catVal
                                        ? Colors.deepPurple[700]
                                        : Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ))),
                          ),
                        );
                      }),
                    ),
                  ),
                  snapshot.data.documents[catVal]['subCategories'].length != 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Select SubCategory',
                                  style: TextStyle(fontSize: 18)),
                            ),
                            Center(
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                children: List<Widget>.generate(
                                    snapshot
                                        .data
                                        .documents[catVal]['subCategories']
                                        .length, (index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        subCatVal = index;
                                        // print(snapshot.data.documents[index]
                                        //     ['subCategories']);
                                      });
                                    },
                                    child: Card(
                                      color: index == subCatVal
                                          ? Colors.deepPurple[700]
                                          : Colors.white,
                                      child: Container(
                                          height: 90,
                                          width: 90,
                                          child: Center(
                                              child: Text(
                                            snapshot.data.documents[catVal]
                                                ['subCategories'][index],
                                            style: TextStyle(
                                              color: index != subCatVal
                                                  ? Colors.deepPurple[700]
                                                  : Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ))),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Description and link',
                        style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10.0),
                    child: Form(
                      key: _formkey,
                      child: TextFormField(
                        validator: (value) {
                          if (value.length == 0) {
                            return 'Please Enter description';
                          }
                        },
                        initialValue: details,
                        onChanged: (val) {
                          details = val;
                        },
                        maxLines: 4,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                  Visibility(
                    replacement: Center(
                      child: SpinKitChasingDots(
                        color: Colors.deepPurple[700],
                      ),
                    ),
                    visible: vis,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ActionChip(
                            elevation: 10,
                            backgroundColor: Colors.deepPurple[700],
                            label: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_formkey.currentState.validate()) {
                                setState(() {
                                  vis = false;
                                });
                                var v = await FirestoreService().demand(
                                    snapshot.data.documents[catVal].documentID,
                                    snapshot.data.documents[catVal]
                                            ['subCategories'][subCatVal] ??
                                        '',
                                    details);
                                if (v) {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                          'Your request successfully sent.')));

                                  //Navigator.of(context).pop();
                                } else {
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Error! Please try again.')));
                                }
                                _formkey.currentState.reset();
                                setState(() {
                                  catVal = 0;
                                  subCatVal = 0;
                                  vis = true;
                                });
                              }
                            }),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
