import 'package:fingertips/MyMarket.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:fingertips/UrlBuilder.dart';
import 'package:fingertips/RetrieveLocation.dart';

class Tabs extends StatelessWidget {

  Tabs(){
    print("Inside tabs");
    new RetrieveLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyMarket>(
    builder: (context, marketchange, _)=>
        TabBarView(
            children: <Widget>[
              UrlBuilder(marketchange.market,"Headlines"),
              UrlBuilder(marketchange.market,"Trending"),
              UrlBuilder(marketchange.market, "WorldNews"),
              UrlBuilder(marketchange.market, "Community"),
              UrlBuilder(marketchange.market, "News"),
              UrlBuilder(marketchange.market, "Business"),
              UrlBuilder(marketchange.market, "Politics"),
              UrlBuilder(marketchange.market, "Sports"),
              UrlBuilder(marketchange.market, "Entertainment"),
              UrlBuilder(marketchange.market, "ScienceAndTechnology")
        ]
    )
    );
  }
}

