import 'package:flutter/material.dart';
import './RetrieveLocation.dart';
import './ListResult.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
    home: FingerTips(),
));

class FingerTips extends StatefulWidget {
  @override
  _FingerTipsState createState() => _FingerTipsState();
}

class _FingerTipsState extends State<FingerTips> {
  @override

  RetrieveLocation getLocation = RetrieveLocation();
  String _value = null;
  String market = "en-US";
  List<String> _values = new List<String>();
  String finalLocation = 'default';
  final token = '0cc8298d0fa64baf8e8c8aad922a77f7';


  void getfinalLocation(){
    RetrieveLocation();
    finalLocation = getLocation.getfinalLocation();
  }




  @override
  void initState() {
    _values.addAll(["Local", "China", "India", "UK", "Latino", "Mexico"]);
    _value = _values.elementAt(0);
  }



  void onChanged(String value){
    setState(() {
      _value = value;
      if (_value == "UK") market = "en-GB";
      if(_value == "India") market = "en-IN";
      if(_value == "Local") market = "en-US";
      if(_value == "China") market = "en-US";
      if(_value == "Mexico") market = "en-mx";
      if(_value == "Latino") market = "en-US";
    });
  }

  void communityUrl(String category){
    String queryuri = category+"+"+_value+"+community+massachusetts";
    String searchnews = "https://api.cognitive.microsoft.com/bing/v7.0/news/search?q="+queryuri+"&mkt=en-us";

    getData(searchnews);

  }

  void buildUrl(String category){
    String categoryuri = category+"&mkt="+market;
    String categorynews= "https://fingertips.cognitiveservices.azure.com/bing/v7.0/news?category="+categoryuri;

    getData(categorynews);

  }

  Future<String> getData(String finalUrl) async{
 //   String queryuri = category+"&mkt="+market;
 //   String searchuri= "https://fingertips.cognitiveservices.azure.com/bing/v7.0/news?category="+queryuri;
    print(finalUrl);
    var uri = Uri.parse(finalUrl);
    var request =  new http.Request("GET", uri);
    request.headers['Ocp-Apim-Subscription-Key'] = "0cc8298d0fa64baf8e8c8aad922a77f7";
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

  Widget build(BuildContext context) {
    getfinalLocation();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('FingerTips',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body:Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            if (finalLocation != null) new Text(finalLocation),

            new Text("Select a nearby community that you would like to explore further",
            style: TextStyle(fontFamily: 'Raleway')),

           new DropdownButton(
               value: _value,
               items: _values.map((String value){
                 return new DropdownMenuItem(
                   value: value,
                   child: new Row(
                     children: <Widget>[
                       new Text("${value}")
                     ],
                   ),
                 );
               }).toList(),
            onChanged: (String value){onChanged(value);},


        ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: (){getfinalLocation();
                    communityUrl("News");},
                    child: Text("Community"),

                  ),
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: (){communityUrl("Restaurants");},
                    child: Text("Restaurants"),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: (){communityUrl("Local shops");},
                    child: Text("shops"),
                  ),
                ),
              ],

            ),

            new Text("From the Region",
                style: TextStyle(fontFamily: 'Raleway')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: (){getfinalLocation();
                    buildUrl("Politics");},
                    child: Text("News"),

                  ),
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: (){buildUrl("Business");},
                    child: Text("Business"),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: (){buildUrl("ScienceAndTechnology");},
                    child: Text("Technology"),
                  ),
                ),
              ],

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: (){getfinalLocation();
                    buildUrl("Sports");},
                    child: Text("Sports"),

                  ),
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: (){buildUrl("Entertainment");},
                    child: Text("Entertainment"),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: (){buildUrl("LifeStyle");},
                    child: Text("LifeStyle"),
                  ),
                ),
              ],

            )
      ]
      ),
      )
    );
  }
}




