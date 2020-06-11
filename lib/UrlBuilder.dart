import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './WebviewDetail.dart';
import 'package:fingertips/Globals.dart' as globals;

class UrlBuilder extends StatelessWidget{

  String tabCategory;
  String mktvalue;
  final token = "0cc8298d0fa64baf8e8c8aad922a77f7";
  final tokenforentity = "2e76114b4bed4a08af24a0443aa58345";
  String _currentAddress = 'default';
  String _currentAddressinQueryString = globals.getAddressinQueryString();
//  String _currentAddressinQueryString = "Boxborough+MA";
  String _value;
  String markets = "en-US";
  bool finishedLoading;
  var streamedresponse;
  RetrieveList news = null;
  TrendingList trendingnews = null;
  var newslist;
  String finalUrl;


  UrlBuilder(_value, tabCategory){
    print(_value);
    setMarketState(_value);
    invokeCategory(tabCategory);
  }

  setMarketState(String value){
      _value = value;
      if (_value == "UK") markets = "en-GB";
      if(_value == "India") markets = "en-IN";
      if(_value == "Local") markets = "en-US";
      if(_value == "China") markets = "en-id";
      if(_value == "Mexico") markets = "en-WW";
      if(_value == "Brazil") markets = "en-WW";
      if(_value == "Africa") markets = "en-ZA";
  }

  invokeCategory(String tabCategory){
    if (tabCategory == "Headlines") stayontopUrl(tabCategory);
    if (tabCategory == "Trending") stayontopUrl(tabCategory);
    if (tabCategory == "WorldNews") stayontopUrl(tabCategory);
    if (tabCategory == "Community") communityUrl(tabCategory);
    if (tabCategory == "News") globalUrl(tabCategory);
    if (tabCategory == "Business") globalUrl(tabCategory);
    if (tabCategory == "Politics") globalUrl(tabCategory);
    if (tabCategory == "Sports") globalUrl(tabCategory);
    if (tabCategory == "Entertainment") globalUrl(tabCategory);
    if (tabCategory == "ScienceAndTechnology") globalUrl(tabCategory);

  }



  void communityUrl(String category){
    if(globals.getAddressinQueryString() == null)
      _currentAddressinQueryString = "USA";
    else
      _currentAddressinQueryString = globals.getAddressinQueryString();
    String queryuri = category+"+"+_value+"+"+_currentAddressinQueryString;
    String searchnews = "https://fingertips.cognitiveservices.azure.com/bing/v7.0/news/search?q="+queryuri+"&mkt=en-us";
    print(_currentAddressinQueryString);
    finalUrl = searchnews;
 //   getNews(searchnews);
    getNews();

  }

  void globalUrl(String category){
    if(_value == "India" || _value == "UK" || _value == "Local") {
      print("Inside Global and value "+_value);
      if ((_value == "India") && (category == "News")) category = "India";
      if ((_value == "UK") && (category == "News")) category = "UK";
      if ((_value == "Local") && (category == "News")) category = "US";
      String categoryuri = category + "&mkt=" + markets;
      String categorynews = "https://fingertips.cognitiveservices.azure.com/bing/v7.0/news?category=" +
          categoryuri;
      finalUrl = categorynews;
//      getNews(categorynews);
    getNews();
    }
    else {
      if (category == "News") category = _value+"+News";
      if (category == "Business") category = _value+"+Business+News";
      if (category == "Politics") category = _value+"+Politics";
      if (category == "Sports") category = _value+"+Sports";
      if (category == "Entertainment") category = _value+"+Entertainment";
      if (category == "ScienceAndTechnology") category = _value+"+ScienceandTechnology";

      String categorynews = "https://fingertips.cognitiveservices.azure.com/bing/v7.0/news/search?q="+
          category + "&mkt="+markets;
      finalUrl = categorynews;
//      getNews(categorynews);
    getNews();
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

    finalUrl = categorynews;

//    getNews(categorynews);
  getNews();

  }


  Future<bool> getNews() async{
    print(finalUrl);
    finishedLoading = false;
    var uri = Uri.parse(finalUrl);
    var request =  new http.Request("GET", uri);
    request.headers['Ocp-Apim-Subscription-Key'] = token;
    request.headers['X-MSEdge-ClientID'] = "1";
    request.headers['Accept']  = "application/json";

    streamedresponse = await request.send();


    if (streamedresponse.statusCode == 200){
      String response = await streamedresponse.stream.bytesToString();
      final jsonUserData = json.decode(response);
      if (tabCategory == "Trending") {
        trendingnews = new TrendingList.fromJson(jsonUserData);
        if (trendingnews.value.length > 15) newslist = 15;
        else newslist = trendingnews.value.length;
        print("Sathish inside trending");
      }
      else {
        news = new RetrieveList.fromJson(jsonUserData);
        if (news.value.length > 15) newslist = 15;
        else newslist = news.value.length;
      }


  //    Navigator.push(
  //      context,
  //      MaterialPageRoute(builder: (context) => ListResult(response)),
  //    );
    }
    else {
      throw Exception("Failed to load");
    }
//    await Future.delayed(Duration(seconds: 1));
    finishedLoading = true;

    return finishedLoading;

  }


  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
          future: getNews(),
          builder: (context, AsyncSnapshot snapshot){
            if ((snapshot.hasData == false) &&(news.value.length == null) )
              return Center(child: CircularProgressIndicator());
            else
            return(ListView.builder(
              //        padding: const EdgeInsets.all(10),
              itemCount: newslist,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightGreenAccent),
                  ),
                  child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                WebviewDetail(
                                  title: "FingerTips",
                                  selectedUrl: news.value[index].url,
                                )));
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          news.value[index].name, textAlign: TextAlign.left, textScaleFactor: 1,),
                      )
                  ),
                );
              },

            )
            );
          }


        )


    );
        }

    }






class RetrieveList{

  final String id;
  final List<Newsarticle>value;


  RetrieveList({
    this.id,
    this.value,
  });
  factory RetrieveList.fromJson(Map<String, dynamic>parsedJson){

    var list = parsedJson['value'] as List;
    List<Newsarticle> valuelist = list.map((i) => Newsarticle.fromJson(i)).toList();

    return new RetrieveList(
        id: parsedJson['readLink'],
        value: valuelist
    );

  }

}

class Newsarticle{
  final String name;
  final String url;

  Newsarticle({
    this.name,
    this.url,
  });

  factory Newsarticle.fromJson(Map<String, dynamic> parsedJson){
    return Newsarticle(
        name: parsedJson['name'],
        url: parsedJson['url']

    );
  }
}

class TrendingList{

  final List<TrendingTopics>value;


  TrendingList({
    this.value,
  });
  factory TrendingList.fromJson(Map<String, dynamic>parsedJson){

    var list = parsedJson['value'] as List;
    List<TrendingTopics> valuelist = list.map((i) => TrendingTopics.fromJson(i)).toList();

    return new TrendingList(
        value: valuelist
    );

  }

}

class TrendingTopics{
  final String name;
  final String url;

  TrendingTopics({
    this.name,
    this.url,
  });

  factory TrendingTopics.fromJson(Map<String, dynamic> parsedJson){
    return TrendingTopics(
        name: parsedJson['name'],
        url: parsedJson['newsSearchUrl']

    );
  }
}