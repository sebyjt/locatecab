import 'package:flutter/material.dart';
import 'package:locatecab/Landing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'globals.dart' as globals;


class Firstlogin extends StatefulWidget {
  @override
  _FirstloginState createState() => _FirstloginState();
}

class _FirstloginState extends State<Firstlogin> {
  TextEditingController controller1, controller2, controller3;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  Future getUser() async {
    user = await _auth.currentUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1 = new TextEditingController();
    controller2 = new TextEditingController();
    controller3 = new TextEditingController();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        resizeToAvoidBottomPadding: true,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(top: 30.0),
            child: Center(
                child: new ListView(children: <Widget>[
              Image.asset(
                "Assets/logo.png",
                height: 100.0,
                width: 100.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(labelText: "Contact no"),
                  controller: controller1,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(labelText: "Capacity"),
                  controller: controller2,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 40.0, left: 40.0, top: 20.0),
                child: TextField(
                  decoration: new InputDecoration(labelText: "Car Model"),
                  controller: controller3,
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 60.0, left: 40.0, right: 20.0),
                child: RaisedButton(
                  onPressed: () async {
                    key.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Details have been saved")));
                    globals.mobileNo = controller1.text;
                    globals.capacity = controller2.text;
                    globals.model = controller3.text;
                    var duration = const Duration(seconds: 2);
                    Timer(duration, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
//                              builder: (context) => Landing(controller1.text, controller2.text, controller3.text)));
                              builder: (context) => Landing()));
                    });
                  },
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Submit",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      )
                    ],
                  ),
                ),
              )
            ]))));
  }
}
