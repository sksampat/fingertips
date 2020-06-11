import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class about extends StatefulWidget {

  IconData icon;
  String text;
  Function onTap;

  about(this.icon, this.text, this.onTap);

  @override
  _aboutState createState() => _aboutState();
}

class _aboutState extends State<about> {
  List<String> _values = new List<String>();

  String _value = "Contact Us";

  void onChanged(String value){
    setState(() {
      _value = value;
    });
  }

  void initState() {
    _values.addAll(["FingerTips","Contact Us","Terms"]);
    _value = _values.elementAt(0);

  }

  @override
  Widget build(BuildContext context) {
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

