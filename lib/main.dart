import 'dart:ui';
import 'package:fingertips/MyMarket.dart';
import 'package:fingertips/RetrieveLocation.dart';
import 'package:fingertips/Tabs.dart';
import 'package:fingertips/UrlBuilder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './ListResult.dart';
import './CustomListTitle.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:fingertips/SideDrawer.dart';
import 'package:fingertips/Globals.dart' as globals;

void main() => runApp(MaterialApp(
    home: FingerTips(),
));

class FingerTips extends StatefulWidget {
  @override
  _FingerTipsState createState() => _FingerTipsState();
}

class _FingerTipsState extends State<FingerTips> {
  @override

  final Geolocator geolocator = Geolocator()
    ..forceAndroidLocationManager;
  String _value = null;
  String market = "en-US";
  List<String> _values = new List<String>();
  String finalLocation;
  final token = "0cc8298d0fa64baf8e8c8aad922a77f7";
  final tokenforentity = "2e76114b4bed4a08af24a0443aa58345";
  Position _currentPosition;
  String _currentAddress = 'default';
  String _currentAddressinQueryString;

   Future _getCurrentLocation() async{
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
    });

    _getAddressFromLatLng();
  }

  Future _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      _currentAddress = await "${place.locality}, ${place.administrativeArea}, ${place.country}";

      globals.setAddressinQueryString("${place.locality}+${place.administrativeArea}");

      globals.setAddress(_currentAddress);
  //    _currentAddressinQueryString = "Marlboro+New Jersey";
    } catch (e) {
      print(e);
    }
  }

  void onChanged(String value){
    setState(() {
      _value = value;
      if (_value == "UK") market = "en-GB";
      if(_value == "India") market = "en-IN";
      if(_value == "Local") market = "en-US";
      if(_value == "China") market = "en-id";
      if(_value == "Mexico") market = "en-WW";
      if(_value == "Brazil") market = "en-WW";
      if(_value == "Africa") market = "en-ZA";
    });
  }




  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }


  @override
  Future<void> initState()  {
    _values.addAll(["Local", "China", "India", "UK", "Brazil", "Mexico", "Africa"]);
    _value = _values.elementAt(0);

  }

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    return ChangeNotifierProvider(
      builder: (context) => MyMarket(),
      child: MaterialApp(
        home: DefaultTabController(
          length: 10,
          child: Scaffold(
            backgroundColor: Colors.white,
              appBar: AppBar(backgroundColor: Colors.deepPurple,
           //     title: Row(mainAxisAlignment: MainAxisAlignment.center,
           //   children: <Widget>[Image.asset('assets/fingertips.png', fit: BoxFit.cover, height: 60.0,)],),

              title: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.lime,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.indigoAccent,
                  tabs: [
                    Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.deepOrange, Colors.red]),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.redAccent, width: 1)
                          ),
                        child: Align(alignment: Alignment.center,child: Text("Headlines")),
                        ),
                    ),

                    Tab(text: "Trending"),
                    Tab(text: "World News"),
                    Tab(text: "Community"),
                    Tab(text: "News"),
                    Tab(text: "Business"),
                    Tab(text: "Politics"),
                    Tab(text: "Sports"),
                    Tab(text: "Entertainment"),
                    Tab(text: "Science")
                ],
              ),

              ),
/*      appBar: AppBar(
              title: Text('FingerTips',
                style: TextStyle(fontFamily: 'Raleway', color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 30),
              ),
              centerTitle: true,
              backgroundColor: Colors.red,
              elevation: 0.0,
            ),
*/

          drawer: SideDrawer(),

            body: Tabs()

 ),
        ),
      ),
    );
  }
}

