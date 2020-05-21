import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import './homeScreen.dart';
import 'package:my_flutter_app/functionalities/location_service.dart';
import 'package:geolocator/geolocator.dart';


class FilterLocation extends StatefulWidget {
  final add;
  FilterLocation({Key key, this.add}) : super(key: key);

  @override
  _FilterLocationState createState() => _FilterLocationState();
}

class _FilterLocationState extends State<FilterLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.deepPurple,
      //   title: Text(
      //     'Filter by location',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   leading: IconButton(
      //       icon: Icon(
      //         Icons.arrow_back,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       }),
      // ),
      body: FutureBuilder(
        future: LocalData().getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return FireMap(location: snapshot.data, add: widget.add);
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
  final add;
  FireMap({Key key, this.location, this.add}) : super(key: key);

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  int centerx = 0, centery = 0;
  GoogleMapController mapController;
  BitmapDescriptor markerIcon;
  String searchAddress;
  @override
  Widget build(BuildContext context) {
    print(widget.location);
    CameraPosition campos = CameraPosition(
      target: widget.location,
      zoom: 15,
    );
    BitmapDescriptor.fromAssetImage(
            createLocalImageConfiguration(context), 'assets/images/current.png')
        .then((d) {
      setState(() {
        markerIcon = d;
      });
    });
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          rotateGesturesEnabled: true,
          initialCameraPosition: campos,
          markers: Set.from(
            [
              Marker(
                markerId: MarkerId('currentLocation'),
                draggable: false,
                position: widget.location,
                icon: markerIcon,
                //icon: BitmapDescriptor.fromAsset('assets/images/googlemapbluedot.jpg'),
              )
            ],
          ),
          onMapCreated: (controller) {
            mapController = controller;
            mapController.getScreenCoordinate(widget.location).then((value) {
              setState(() {
                centerx = value.x;
                centery = value.y;
              });
            });
          },
        ),
        Icon(
          Icons.location_on,
          color: Colors.deepPurple,
          size: 50,
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
              //width: 50,
              //height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                // image: DecorationImage(
                //     image: AssetImage('assets/images/bluedot.jpg')),
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
            onPressed: () {
              mapController
                  .getLatLng(ScreenCoordinate(x: centerx, y: centery))
                  .then((value) {
                print(value);
                LocationService().getAddress(value).then((add) {
                  print(add);
                  Navigator.pop(context, add);
                });
                //HomeScreenState().changeAddress();
                /* LocalData().saveLocation(
                    latitude: value.latitude, longitude: value.longitude); */
              });
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
                    Geolocator().placemarkFromAddress(searchAddress).then((result){
                      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(result[0].position.latitude,result[0].position.longitude),
                        zoom: 10,
                      )));
                    }).catchError((onError){
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Address not found!'),
                        )
                      );
                    });
                  },
                ),
              ),
              onChanged: (val){
                searchAddress = val;
              },
              onSubmitted: (val){
                Geolocator().placemarkFromAddress(val).then((result){
                      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(result[0].position.latitude,result[0].position.longitude),
                        zoom: 10,
                      )));
                    }).catchError((onError){
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Address not found!'),
                        )
                      );
                    });
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
