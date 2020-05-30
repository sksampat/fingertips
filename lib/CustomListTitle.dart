import 'package:fingertips/MyMarket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class customListTitle extends StatefulWidget{

  IconData icon;
  String text;
  Function onTap;

  customListTitle(this.icon, this.text, this.onTap);

  @override
  _customListTitleState createState() => _customListTitleState();
}

class _customListTitleState extends State<customListTitle> {
  String _value = "Local";

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
    final  marketchange= Provider.of<MyMarket>(context);
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
                        value: marketchange.market,
                        items: _values.map((String value)=> new DropdownMenuItem(
                          value: value,
                          child: new Row(
                            children: <Widget>[
                              new Text("${value}", style: TextStyle(fontSize: 16))
                            ],
                          ),
                        )).toList(),
                   //     onChanged: (String value){onChanged(value);},
                        onChanged: (value) => marketchange.mkt = value,


                      ),
                    ],
                  )
              )

          ),
        )
    );

  }
}
