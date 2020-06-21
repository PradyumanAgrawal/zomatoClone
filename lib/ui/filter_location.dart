import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/functionalities/firestore_service.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import 'package:my_flutter_app/functionalities/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class FilterLocation extends StatefulWidget {
  FilterLocation({
    Key key,
  }) : super(key: key);

  @override
  _FilterLocationState createState() => _FilterLocationState();
}

class _FilterLocationState extends State<FilterLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: LocationService().getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return FireMap(location: snapshot.data);
          } else {
            return Center(
              child: SpinKitChasingDots(
                color: Colors.purple,
              ),
            );
          }
        },
      ),
    );
  }
}

class FireMap extends StatefulWidget {
  final LatLng location;
  FireMap({Key key, this.location}) : super(key: key);

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  int centerx = 0, centery = 0;
  GoogleMapController mapController;
  String searchAddress;
  Set<Marker> markers;
  LatLng markerPosition;
  BitmapDescriptor shopMarker;
  StreamSubscription subscription;
  BehaviorSubject<LatLng> center = BehaviorSubject();

  void createMarker(context) {
    if (shopMarker == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/images/p5.png')
          .then((icon) {
        setState(() {
          shopMarker = icon;
        });
      });
    }
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data['location']['geopoint'];
      Marker tempMarker = Marker(
        markerId: MarkerId(document.documentID),
        icon: shopMarker,
        draggable: false,
        position: LatLng(pos.latitude, pos.longitude),
        infoWindow:
            InfoWindow(title: document['name'], snippet: document['address']),
      );
      setState(() {
        markers.add(tempMarker);
      });
    });
  }

  _startQuery() {
    subscription = center.switchMap((value) {
      return FirestoreService().getNearbyStores(value);
    }).listen(_updateMarkers);
  }

  @override
  void initState() {
    center.add(widget.location);
    markers = Set.from([]);
    Marker m = Marker(
      markerId: MarkerId('marked location'),
      icon: BitmapDescriptor.defaultMarker,
      draggable: true,
      position: widget.location,
    );
    setState(() {
      markers.add(m);
    });
    markerPosition = widget.location;
    Fluttertoast.showToast(
      toastLength: Toast.LENGTH_LONG,
      msg: "Move the map to reveal more shops around and tap to set the marker",
    );
    super.initState();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    createMarker(context);
    print(widget.location);
    CameraPosition campos = CameraPosition(
      target: widget.location,
      zoom: 15,
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          rotateGesturesEnabled: true,
          initialCameraPosition: campos,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: markers,
          onCameraMove: (pos) {
            setState(() {
              center.add(pos.target);
            });
          },
          onTap: (pos) {
            Marker m = Marker(
                markerId: MarkerId('marked location'),
                icon: BitmapDescriptor.defaultMarker,
                draggable: true,
                position: pos);
            setState(() {
              markers.add(m);
              markerPosition = pos;
            });
          },
          onMapCreated: (controller) {
            _startQuery();
            mapController = controller;
          },
        ),
        Positioned(
          bottom: 40,
          left: 10,
          child: GestureDetector(
            onTap: () {
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: widget.location, zoom: 15),
              ));
            },
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
              child: IconButton(
                icon: Icon(Icons.my_location, color: Colors.blue[600]),
                onPressed: () {
                  mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: widget.location, zoom: 15),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          child: ActionChip(
            backgroundColor: Colors.deepPurple,
            label: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Set Location',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            onPressed: () async {
              // await LocalData().saveLocation(
              //     latitude: markerPosition.latitude,
              //     longitude: markerPosition.longitude);
              Navigator.pop(context, markerPosition);
            },
          ),
        ),
        Positioned(
          top: 30,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width / 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: FlatButton(
              padding: EdgeInsets.all(0),
              child: Icon(Icons.arrow_back, color: Colors.black),
              color: Colors.black12,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              splashColor: Colors.deepPurple,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 30,
          child: Container(
            width: MediaQuery.of(context).size.width * 3 / 5,
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                )),
            child: TextField(
              decoration: InputDecoration(
                //contentPadding: EdgeInsets.only(left: 15),
                hintText: 'Search address',
                border: InputBorder.none,
                prefixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print(searchAddress);
                    Geolocator()
                        .placemarkFromAddress(searchAddress)
                        .then((result) {
                      mapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(result[0].position.latitude,
                            result[0].position.longitude),
                        zoom: 10,
                      )));
                    }).catchError((onError) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Address not found!'),
                      ));
                    });
                  },
                ),
              ),
              onChanged: (val) {
                searchAddress = val;
              },
              onSubmitted: (val) {
                if (val != null) {
                  Geolocator().placemarkFromAddress(val).then((result) {
                    mapController.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(result[0].position.latitude,
                          result[0].position.longitude),
                      zoom: 10,
                    )));
                  }).catchError((onError) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Address not found!'),
                    ));
                  });
                }
              },
            ),
          ),
        ),
        // Positioned(
        //   top: 30,
        //   left: 5,
        //   child: Material(
        //     color: Colors.black12,
        //     type: MaterialType.circle,
        //     child: IconButton(
        //       icon: Icon(Icons.arrow_back, color: Colors.white,),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //     ),
        //   ),
        // )
      ],
    );
  }
}
