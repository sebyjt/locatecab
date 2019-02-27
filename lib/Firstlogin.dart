import 'package:flutter/material.dart';

class Firstlogin extends StatefulWidget {
  @override
  _FirstloginState createState() => _FirstloginState();
}

class _FirstloginState extends State<Firstlogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Image.asset(
                    "Assets/logo.png",
                    height: 100.0,
                    width: 100.0,
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
