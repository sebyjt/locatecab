import 'package:firebase_database/firebase_database.dart';
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
  final databaseReference = FirebaseDatabase.instance.reference();

  SharedPreferences sharedPreferences;

  Future getUser() async {
    user = await _auth.currentUser();
  }

  @override
  void initState() {
    //loadLocallySavedHostData();
    super.initState();
    controllerContactNo = new TextEditingController();
    controllerCarModel = new TextEditingController();
    controllerCarColor = new TextEditingController();
    controllerRegNo = new TextEditingController();
    controllerCapacity = new TextEditingController();
    getUser();
  }

 /* saveHostDetailsLocally() async{
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("host_contact_no", controllerContactNo.text);
      sharedPreferences.setString("host_car_model", controllerCarModel.text);
      sharedPreferences.setString("host_car_color", controllerCarColor.text);
      sharedPreferences.setString("host_reg_no", controllerRegNo.text);
      sharedPreferences.setString("host_car_capacity", controllerCapacity.text);
    });
  }*/

/*  loadLocallySavedHostData() async{
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      controllerContactNo.text = sharedPreferences.getString("host_contact_no");
      controllerCarModel.text = sharedPreferences.getString("host_car_model");
      controllerCarColor.text = sharedPreferences.getString("host_car_color");
      controllerRegNo.text = sharedPreferences.getString("host_reg_no");
      controllerCapacity.text = sharedPreferences.getString("host_car_capacity");
    });
  }*/

  validate() async{
    if(
        controllerContactNo.text.isEmpty ||
        controllerCarModel.text.isEmpty ||
        controllerCarColor.text.isEmpty ||
        controllerRegNo.text.isEmpty ||
        controllerCapacity.text.isEmpty
    ){
      showSnackbar("All fields are mandatory");
    }else{
      globals.mobileNo = controllerContactNo.text;
      globals.capacity = controllerCapacity.text;
      globals.model = controllerCarModel.text;
      globals.regNo = controllerRegNo.text;
      globals.carColour = controllerCarColor.text;

      //saveHostDetailsLocally();
      await registerHost();
      showSnackbar("Details have been saved");

      var duration = const Duration(seconds: 2);
      Timer(duration, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HostView()));
      });
    }
  }

  showSnackbar(String msg)async{
    key.currentState.showSnackBar(SnackBar(
        content: Text(
            msg)));
  }

  Future registerHost() async {
    user = await _auth.currentUser();
    String userId = user.email;
    userId = userId.replaceAll(".", "");


    databaseReference.child("host").child(userId).set({
      'host_name': user.displayName,
      'host_email': user.email,
      'mobile_no' : globals.mobileNo,
      'model' : globals.model,
      'capacity' : globals.capacity,
      'host_location_latitude': globals.hostLocationLatitude,
      'host_location_longitude': globals.hostLocationLongitude,
      'reg_no': globals.regNo,
      'car_colour': globals.carColour,
//      'destination_latitude': globals.receiverDestinationLatitude,
//      'destination_longitude': globals.receiverDestinationLongitude,
//      'receiver_location_address': globals.receiverLocationAddress,
//      'receiver_destination_address': globals.receiverDestinationAddress,
      'imageURL': fbuser.photoUrl,
//      'receiver_status': "Your location is live on the map please wait until a host accepts you.",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        resizeToAvoidBottomPadding: true,
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
                  onPressed: () {
                    validate();
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

