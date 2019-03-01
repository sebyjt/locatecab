import 'package:flutter/material.dart';

class hostview extends StatefulWidget {
  @override
  hostviewState createState() => new hostviewState();
}
class UserData{
  String mail;
  int number;
}
class hostviewState extends State<hostview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "Vehicle Starts",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Gothic',
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Column(children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(labelText: "Capacity"),
          ),
          TextField(
            decoration: new InputDecoration(labelText: "Car Model"),
          ),
          new RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(70.0)),
              color: Colors.orangeAccent.withAlpha(700),
              child: Text(
                "Done",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {})
        ]));
  }
}
