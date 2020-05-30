import 'package:flutter/foundation.dart';

class MyMarket with ChangeNotifier{
  String _mkt = "Local";

  String get market => _mkt;
  set mkt(String newValue){
    _mkt = newValue;
    notifyListeners();
  }

  String provideMarket(){
    return _mkt;
  }

}