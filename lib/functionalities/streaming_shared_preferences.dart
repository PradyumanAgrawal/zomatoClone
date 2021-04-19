import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class LocationPreferences {
  LocationPreferences(StreamingSharedPreferences preferences)
      : 
        // latitude = preferences.getDouble('latitude', defaultValue: 0),
        // longitude = preferences.getDouble('longitude', defaultValue: 0),
        location = preferences.getStringList('location', defaultValue: ['0.0 ','0.0']);

  // final Preference<double> latitude;
  // final Preference<double> longitude;
  final Preference<List<String>> location;
}