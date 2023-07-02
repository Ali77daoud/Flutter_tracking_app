import 'dart:async';

import 'package:location/location.dart';
import 'package:tracking_app/tracking/user_location.dart';

class LocationService {
  Location location = Location();
  StreamController<UserLocation> locationStreamController =
      StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => locationStreamController.stream;

  LocationService() {
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          locationStreamController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
              speed: locationData.speed));
        });
      }
    });
  }

  void dispose() => locationStreamController.close();
}
