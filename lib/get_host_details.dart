import 'package:flutter/material.dart';
import 'package:locatecab/host_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:locatecab/about_page.dart';
import 'package:locatecab/receiver_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;


class GetHostDetails extends StatefulWidget {
  @override
  _GetHostDetailsState createState() => _GetHostDetailsState();
}

class _GetHostDetailsState extends State<GetHostDetails> {
  TextEditingController controllerContactNo, controllerCarModel, controllerCarColor,controllerRegNo,controllerCapacity;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  SharedPreferences sharedPreferences;

  Future getUser() async {
    user = await _auth.currentUser();
  }

  @override
  void initState() {
    loadLocallySavedHostData();
    super.initState();
    controllerContactNo = new TextEditingController();
    controllerCarModel = new TextEditingController();
    controllerCarColor = new TextEditingController();
    controllerRegNo = new TextEditingController();
    controllerCapacity = new TextEditingController();
    getUser();
  }

  saveHostDetailsLocally() async{
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("host_contact_no", controllerContactNo.text);
      sharedPreferences.setString("host_car_model", controllerCarModel.text);
      sharedPreferences.setString("host_car_color", controllerCarColor.text);
      sharedPreferences.setString("host_reg_no", controllerRegNo.text);
      sharedPreferences.setString("host_car_capacity", controllerCapacity.text);
    });
  }

  loadLocallySavedHostData() async{
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      controllerContactNo.text = sharedPreferences.getString("host_contact_no");
      controllerCarModel.text = sharedPreferences.getString("host_car_model");
      controllerCarColor.text = sharedPreferences.getString("host_car_color");
      controllerRegNo.text = sharedPreferences.getString("host_reg_no");
      controllerCapacity.text = sharedPreferences.getString("host_car_capacity");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        resizeToAvoidBottomPadding: true,
        drawer: Drawer(),
        appBar: AppBar(
          title: const Text('Give your details',style: TextStyle(
              color: Colors.white,fontFamily: 'Gothic',
              fontWeight:FontWeight.bold
          ),
          ),
          backgroundColor: Colors.orangeAccent,
          centerTitle:true,
          elevation: 0.0,
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(top: 20.0),
            child: Center(
                child: new ListView(children: <Widget>[
              Image.asset(
                "assets/images/logo.png",
                height: 100.0,
                width: 100.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(labelText: "Contact no"),
                  controller: controllerContactNo,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                child: TextField(
                  decoration: new InputDecoration(labelText: "Car Model"),
                  controller: controllerCarModel,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 40.0, left: 40.0, top: 10.0),
                child: TextField(
                  decoration: new InputDecoration(labelText: "Car Colour"),
                  controller: controllerCarColor,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(right: 40.0, left: 40.0, top: 10.0),
                child: TextField(

                  decoration: new InputDecoration(labelText: "Registration no"),
                  controller: controllerRegNo,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(right: 40.0, left: 40.0, top: 10.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(labelText: "Capacity"),
                  controller: controllerCapacity,
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
                child: RaisedButton(
                  onPressed: () async {
                    key.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Details have been saved")));
                    globals.mobileNo = controllerContactNo.text;
                    globals.capacity = controllerCapacity.text;
                    globals.model = controllerCarModel.text;
                    globals.regNo = controllerRegNo.text;
                    globals.carColour = controllerCarColor.text;

                    saveHostDetailsLocally();

                    var duration = const Duration(seconds: 2);
                    Timer(duration, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
//                              builder: (context) => Landing(controller1.text, controller2.text, controller3.text)));
                              builder: (context) => HostView()));
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

class Drawer extends StatefulWidget {
  @override
  DrawerState createState() {
    return new DrawerState();
  }
}

class DrawerState extends State<Drawer> {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future getUser() async {
    user = await _auth.currentUser();
    fbuser = user;
    setState(() {
      globals.receiverPhotoURL = fbuser.photoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .6,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepOrangeAccent, Colors.orangeAccent])),
            height: MediaQuery.of(context).size.height * .3,
            alignment: Alignment.center,
            child: ListTile(
              leading: ClipOval(
                child: Image.network(
                  "${user.photoUrl}",
                  fit: BoxFit.fill,
                  height: 40.0,
                  width: 40.0,
                ),
              ),
              title: Text("${user.displayName}"),
              subtitle: Text("${user.email}"),
            ),
          ),
          ListTile(
            title: Text(
              "Receiver",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000)),
            ),
            leading: Image.asset("assets/images/down.png",
                height: 30, width: 30, color: Colors.black),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ReceiverView(false, null)),
              );
            },
          ),
          ListTile(
            title: Text(
              "Host",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000)),
            ),
            leading: Image.asset("assets/images/up.png",
                height: 30, width: 30, color: Colors.black),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GetHostDetails()),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              "About",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000)),
            ),
            leading: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => About()),
              );
            },
          ),
          ListTile(
            title: Text(
              "Logout",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000)),
            ),
            leading: Icon(
              Icons.power_settings_new,
              color: Colors.black,
            ),
            onTap: () async {
              await _auth.signOut();
              await _googleSignIn.signOut();

              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            },
          ),
          Image.asset(
            "assets/images/ajce.png",
            height: 80.0,
            width: 80.0,
          )
        ],
      ),
    );
  }
}