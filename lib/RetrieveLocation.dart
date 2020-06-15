import 'package:geolocator/geolocator.dart';
import 'package:fingertips/Globals.dart' as globals;


class RetrieveLocation{

  final Geolocator geolocator = Geolocator()
    ..forceAndroidLocationManager;
  Position _currentPosition;
  String currentAddress = 'default';

  RetrieveLocation() {
    print("Inside Retrieve Location");
    getLocation();
  }

   getLocation() {
      _getCurrentLocation();
  }


 Future <bool> _getCurrentLocation() async{
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
    });
    print("Inside get current location");

    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];


      currentAddress =
      "${place.locality}, ${place.administrativeArea}, ${place.country}";


      print("Calling adddress from retrievelocation");
      globals.setAddressforCommunityQuery("${place.locality}+${place.administrativeArea}");
      globals.setAddressforSideDrawerDisplay(currentAddress);
      return true;
    } catch (e) {
      print(e);
    }
//    _getAddressFromLatLng();
  }

/*  Future <bool> _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];


      currentAddress =
      "${place.locality}, ${place.administrativeArea}, ${place.country}";


      print("Calling adddress from retrievelocation");
      globals.setAddressforCommunityQuery("${place.locality}+${place.administrativeArea}");
      globals.setAddressforSideDrawerDisplay(currentAddress);
      return true;
    } catch (e) {
      print(e);
    }
  }
  */
}



