import 'package:flutter/material.dart';
import 'package:locatecab/crud.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Firstlogin extends StatefulWidget {
  @override
  _FirstloginState createState() => _FirstloginState();
}


class _FirstloginState extends State<Firstlogin> {
  TextEditingController controller;
  CrudMethods crud;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  Future getUser() async {
    user = await _auth.currentUser();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=new TextEditingController();
    crud=new CrudMethods();
    getUser();
  }
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
                    controller: controller,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(labelText: "Capacity"),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 40.0, left: 40.0, top: 20.0),
                child: TextField(
                  decoration: new InputDecoration(labelText: "Car Model"),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 60.0, left: 40.0, right: 20.0),
                child: RaisedButton(
                  onPressed: () async {
                    await crud.addData({"Name": user.displayName,"Phone No":controller.text});
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
