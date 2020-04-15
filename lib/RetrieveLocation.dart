import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';


class RetrieveLocation {

  final Geolocator geolocator = Geolocator()
    ..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;

  RetrieveLocation() {
    _getCurrentLocation();
    _getAddressFromLatLng();
  }


  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
    });

    _getAddressFromLatLng();
  }


  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];


      _currentAddress =
      "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print(e);
    }
  }

  String getfinalLocation() {
    _getCurrentLocation();
    _getAddressFromLatLng();
    return _currentAddress;
  }
}
