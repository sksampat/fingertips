import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fingertips/CustomListTitle.dart';
import 'package:fingertips/Globals.dart' as globals;

class SideDrawer extends StatelessWidget {

  String finalLocation;
  Position _currentPosition;
  String _currentAddress = 'default';


  final Geolocator geolocator = Geolocator()
    ..forceAndroidLocationManager;

  Future <String> _getCurrentLocation() async{

    if (globals.getAddress() != null)
      return(globals.getAddress());
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
    });

    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

//      await Future.delayed(Duration(seconds: 2));

      _currentAddress =  "${place.locality}, ${place.administrativeArea}, ${place.country}";

//      globals.setAddress("${place.locality}+${place.administrativeArea}");

      return _currentAddress;
      //    _currentAddressinQueryString = "Marlboro+New Jersey";
    } catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: new FutureBuilder<String>(
            future: _getCurrentLocation(),
            builder: (BuildContext context, AsyncSnapshot snapshot){

              if (snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("Loading")
                  )
                );
                }

              return ListView(
                children: <Widget>[
                  DrawerHeader(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: <Color>[
                            Colors.deepOrange,
                            Colors.orangeAccent
                          ])
                      ),
                      child: Container(
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/fingertips.png', width: 126, height:135,),
                            ],
                          )
                      )
                  ),
                  new Padding(padding: EdgeInsets.fromLTRB(15,10,5,10)),
                  Text(snapshot.data, style: new TextStyle(color: Colors.deepOrange, fontSize: 15.0, fontWeight: FontWeight.bold),),
                  new Padding(padding: EdgeInsets.fromLTRB(15,10,15,10)),
                  customListTitle(Icons.map, 'Community', ()=>{}),

                  //         customListTitle(Icons.description, 'About Us', ()=>{}),
                ],
              );

            }


        )
    );
  }
}
