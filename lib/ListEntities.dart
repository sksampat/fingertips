import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './WebviewDetail.dart';

class ListEntities extends StatelessWidget {
  RetrieveList entities = null;
  var newslist;
  ListEntities(String value) {
    final jsonUserData = json.decode(value);
    entities = new RetrieveList.fromJson(jsonUserData);
    if (entities.value.length > 15) newslist = 15;
    else newslist = entities.value.length;
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
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
        body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: newslist,
          itemBuilder: (BuildContext context, int index){
            return Container(
              height: 70,
              child: FlatButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => WebviewDetail(
                          title: "FingerTips",
                          selectedUrl: entities.value[index].url,
                        )));
                  },
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(entities.value[index].name, textAlign: TextAlign.left,),
                  )
              ),
            );
          },

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






