import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fingertips/Globals.dart' as globals;


class RetrieveLocation{

  final Geolocator geolocator = Geolocator()
    ..forceAndroidLocationManager;
  Position _currentPosition;
  String currentAddress = 'default';

  RetrieveLocation() {
   _getCurrentLocation();
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


      currentAddress =
      "${place.locality}, ${place.administrativeArea}, ${place.country}";

      print("Calling adddress from retrievelocation");
      globals.setAddressforCommunityQuery("${place.locality}+${place.administrativeArea}");
      globals.setAddressforSideDrawerDisplay(currentAddress);
    } catch (e) {
      print(e);
    }
  }
  getfinalLocation() {
    _getCurrentLocation();
    _getAddressFromLatLng();
  }
}



