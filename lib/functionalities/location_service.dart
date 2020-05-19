import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
 LatLng _currentLocation;
  var location = Location();

  Future<LatLng> getLocation() async {
    try {
      var _userLocation = await location.getLocation();
      _currentLocation = LatLng(
        _userLocation.latitude,
        _userLocation.longitude,
      );
    } catch (e) {
      print(e);
    }
    return _currentLocation;
  }

  Future<String> getAddress(LatLng loc) async {
    var address = await Geocoder.local.findAddressesFromCoordinates(Coordinates(loc.latitude, loc.longitude));
    return address.first.addressLine;
  }
}
