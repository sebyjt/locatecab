import 'package:flutter/material.dart';

class Firstlogin extends StatefulWidget {
  @override
  _FirstloginState createState() => _FirstloginState();
}

class _FirstloginState extends State<Firstlogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(top: 30.0),
            child: Center(
                child: new ListView(
                    children: <Widget>[
                  Image.asset(
                    "Assets/logo.png",
                    height: 100.0,
                    width: 100.0,
                  ),

                      Padding(
                        padding: const EdgeInsets.only(left: 40.0,right: 40.0,top: 20.0),
                        child: TextField(
                            keyboardType:  TextInputType.number,
                            decoration:new InputDecoration(labelText: "contact no")),
                      ),

                  Padding(
                    padding: const EdgeInsets.only(left: 40.0,right: 40.0,top: 20.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(labelText: "Capacity"),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 40.0,left: 40.0,top:20.0),
                    child: TextField(

                      decoration: new InputDecoration(labelText: "Car Model"),
                    ),
                  ),
                  new Padding(
                    padding:
                        EdgeInsets.only(top: 60.0, left: 40.0, right: 20.0),

                    child: RaisedButton(
                      onPressed: (){},
                      color: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "Submit",
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ]))));
  }
}
