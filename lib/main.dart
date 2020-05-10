import 'dart:convert';
import 'dart:ui';
import 'package:fingertips/ListEntities.dart';
import 'package:fingertips/RetrieveLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './ListResult.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

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

  _getCurrentLocation() async{
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
      "${place.locality}, ${place.administrativeArea}, ${place.country}";

      _currentAddressinQueryString = "${place.locality}+${place.administrativeArea}";
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

  void communityUrl(String category){
    String queryuri = category+"+"+_value+"+"+_currentAddressinQueryString;
    String searchnews = "https://fingertips.cognitiveservices.azure.com/bing/v7.0/news/search?q="+queryuri+"&mkt=en-us";
    print(_currentAddressinQueryString);
    getNews(searchnews);

  }

  void globalUrl(String category){
    if(_value == "India" || _value == "UK" || _value == "Local") {
      if ((_value == "India") && (category == "News")) category = "India";
      if ((_value == "UK") && (category == "News")) category = "UK";
      if ((_value == "Local") && (category == "News")) category = "US";
      String categoryuri = category + "&mkt=" + market;
      String categorynews = "https://fingertips.cognitiveservices.azure.com/bing/v7.0/news?category=" +
          categoryuri;
      getNews(categorynews);
    }
    else {
      if (category == "News") category = _value+"+News";
      if (category == "Business") category = _value+"+Business+News";
      if (category == "Politics") category = _value+"+Politics";
      if (category == "Sports") category = _value+"+Sports";
      if (category == "Entertainment") category = _value+"+Entertainment";
      if (category == "ScienceAndTechnology") category = _value+"+ScienceandTechnology";
      
      String categorynews = "https://fingertips.cognitiveservices.azure.com/bing/v7.0/news/search?q=" +
          category + "&mkt="+market;
      getNews(categorynews);
    }

  }

  void stayontopUrl(String category){
    String categorynews;
    if (category == "Headlines")
       categorynews = "https://fingertips.cognitiveservices.azure.com/bing/v7.0/news?mkt=en-us&headlineCount=12";

    if (category == "Trending")
       categorynews = "https://fingertips.cognitiveservices.azure.com/bing/v7.0/news/trendingtopics?mkt=en-us";

    if (category == "WorldNews")
      categorynews = "https://fingertips.cognitiveservices.azure.com/bing/v7.0/news?category=World&mkt=en-US";

    getNews(categorynews);

  }

  void entitiesUrl(String category){
    String entity = category+"+&mkt="+market;
//    String entityuri= "https://eastus.api.cognitive.microsoft.com/bing/entities?mkt=en-US+&q="+jsonEncode(category);
    String entityuri = "https://fingertips.cognitiveservices.azure.com/bing/v7.0/entities?mkt=en-US+&q="+jsonEncode(category);
    getEntities(entityuri);

  }

  Future<String> getNews(String finalUrl) async{
    print(finalUrl);
    var uri = Uri.parse(finalUrl);
    var request =  new http.Request("GET", uri);
    request.headers['Ocp-Apim-Subscription-Key'] = token;
    request.headers['X-MSEdge-ClientID'] = "1";
    request.headers['Accept']  = "application/json";

    var streamedresponse = await request.send();


   if (streamedresponse.statusCode == 200){
      String response = await streamedresponse.stream.bytesToString();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListResult(response)),
      );
    }
    else {
      throw Exception("Failed to load");
    }

  }

  Future<String> getEntities(String finalUrl) async{
    var uri = Uri.parse(finalUrl);
    print(uri);
    var request =  new http.Request("GET", uri);
    request.headers['Ocp-Apim-Subscription-Key'] = token;
    request.headers['X-MSEdge-ClientID'] = "1";
    request.headers['Accept']  = "application/json";
 //   request.headers['X-Search-Location'] = "lat: 42.3601N, long: 71.0589W";

    var entitiesresponse = await request.send();

    print(entitiesresponse.statusCode);

    print(entitiesresponse.headers);

    if (entitiesresponse.statusCode == 200){
      String response = await entitiesresponse.stream.bytesToString();
      print(response);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListEntities(response)),
      );
    }
    else {
      throw Exception("Failed to load");
    }

  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }


  @override
  void initState() {
    _values.addAll(["Local", "China", "India", "UK", "Brazil", "Mexico", "Africa"]);
    _value = _values.elementAt(0);

  }

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.red,title: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Image.asset('assets/fingertips.png', fit: BoxFit.cover, height: 60.0,)],)),
/*      appBar: AppBar(
        title: Text('FingerTips',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
*/
    drawer: Drawer(
      child: ListView(
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
          Text(_currentAddress),
          customListTitle(Icons.map, 'Community', ()=>{}),

 //         customListTitle(Icons.description, 'About Us', ()=>{}),
        ],
      )
    ),

    body: new Container(
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: new Text("${_currentAddress}", style: TextStyle(fontFamily: 'Raleway', fontSize: 15))
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text("Select a nearby community",
                      style: TextStyle(fontFamily: 'Raleway', fontSize: 20)),

                  new DropdownButton(
                    value: _value,
                    items: _values.map((String value){
                      return new DropdownMenuItem(
                        value: value,
                        child: new Row(
                          children: <Widget>[
                            new Text("${value}", style: TextStyle(fontFamily: 'Raleway', fontSize: 20))
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String value){onChanged(value);},


                  ),
                ],
              ),
            ),

            Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    color: Colors.blueGrey,
                    onPressed: (){communityUrl("News");},
                    child: Text("Community"),

                  ),
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.blueGrey,
                    onPressed: (){communityUrl("Restaurants");},
                    child: Text("Restaurants"),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.blueGrey,
                    onPressed: (){communityUrl("Local shops");},
                    child: Text("shops"),
                  ),
                ),
              ]
            ),
          ),

            Container(
              child: Column(
                children: <Widget>[
                  new Text("From the Region",
                  style: TextStyle(fontFamily: 'Raleway', height: 5, fontSize: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          onPressed: (){globalUrl("News");},
                          child: Text("News"),

                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          onPressed: (){globalUrl("Business");},
                          child: Text("Business"),
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          onPressed: (){globalUrl("Politics");},
                          child: Text("Politics"),
                        ),
                      ),
                    ],

                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          onPressed: (){globalUrl("Sports");},
                          child: Text("Sports"),

                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          onPressed: (){globalUrl("Entertainment");},
                          child: Text("Entertainment"),
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          onPressed: (){globalUrl("ScienceAndTechnology");},
                          child: Text("Technology"),
                        ),
                      ),
                    ],

                  ),
                ],
              ),
            ),

            Column(
              children: <Widget>[
                new Text("Stay on Top",
                    style: TextStyle(fontFamily: 'Raleway', height: 5, fontSize: 20)),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          onPressed: (){stayontopUrl("Headlines");},
                          child: Text("Headlines"),

                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          onPressed: (){stayontopUrl("Trending");},
                          child: Text("Trending Stories"),
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          onPressed: (){stayontopUrl("WorldNews");},
                          child: Text("World"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
      )
    )
  );
  }
}

class customListTitle extends StatefulWidget{

  IconData icon;
  String text;
  Function onTap;

  customListTitle(this.icon, this.text, this.onTap);

  @override
  _customListTitleState createState() => _customListTitleState();
}

class _customListTitleState extends State<customListTitle> {
  String _value = null;

  String market = "en-US";

  List<String> _values = new List<String>();

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

  @override
  void initState() {
    _values.addAll(["Local", "China", "India", "UK", "Brazil", "Mexico", "Africa"]);
    _value = _values.elementAt(0);

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))
        ),
        child: InkWell(
          splashColor: Colors.orangeAccent,
          onTap: widget.onTap,
          child: Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(widget.icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.text, style: TextStyle(
                        fontSize: 16
                      ),)
                    ),

                  ],
                ),
                Icon(Icons.arrow_forward),
                DropdownButton(
                  value: _value,
                  items: _values.map((String value)=> new DropdownMenuItem(
                    value: value,
                    child: new Row(
                      children: <Widget>[
                        new Text("${value}", style: TextStyle(fontSize: 16))
                      ],
                    ),
                  )).toList(),
                  onChanged: (String value){onChanged(value);},


                ),
              ],
            )
          )

        ),
      )
    );

    }
}


