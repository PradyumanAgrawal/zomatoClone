import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/functionalities/local_data.dart';
import './homeScreen.dart';
import 'package:my_flutter_app/functionalities/location_service.dart';


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
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Filter by location',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
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
  @override
  Widget build(BuildContext context) {
    print(widget.location);
    var campos = CameraPosition(
      target: widget.location,
      zoom: 15,
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          rotateGesturesEnabled: true,
          initialCameraPosition: campos,
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
                LocationService().getAddress(value).then((add){
                  print(add);
                  
                  Navigator.pop(context,add);
                });
                //HomeScreenState().changeAddress();
                /* LocalData().saveLocation(
                    latitude: value.latitude, longitude: value.longitude); */
              });
            },
          ),
        )
      ],
    );
  }
}
