import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/functionalities/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  LatLng currentLoc;
  Future<bool> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var log = prefs.getString('loggedIn');
    print(log);
    if (log == 'yes')
      return true;
    else
      return false;
  }

  Future<void> saveData(
      {userEmail: '', password: '', loggedIn: '', uid: ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userEmail", userEmail);
    prefs.setString("loggedIn", loggedIn);
    prefs.setString("password", password);
    prefs.setString("uid", uid);
  }

  Future<void> saveLocation({latitude: 0, longitude: 0}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("latitude", latitude);
    prefs.setDouble("longitude", longitude);
    LocationService().getAddress(LatLng(latitude, longitude)).then((value) => saveAddress(address: value));
  }

  Future<void> saveAddress({address:''}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("address", address);
  }

  Future<String> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var add = prefs.getString("address");
    return add;
  }

  Future<LatLng> getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return LatLng(prefs.getDouble("latitude"), prefs.getDouble('longitude'));
  }

  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString("userEmail");
    return userEmail;
  }

  Future<String> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid");
    return uid;
  }
}
