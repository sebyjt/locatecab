import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locatecab/settings_page.dart';
import 'package:locatecab/r_confirm.dart';
import 'package:locatecab/Firstlogin.dart';
import 'package:locatecab/autofill.dart';

import 'globals.dart' as globals;

FirebaseUser fbuser;

class ReceiverView extends StatefulWidget {
  @override
  _ReceiverViewState createState() => _ReceiverViewState();
}

class _ReceiverViewState extends State<ReceiverView> {
  GoogleMapController mapController;
  var source = "My Location", destination = "Destination";
  var currentlocation = {};
  Position position;
  TextEditingController controller;

  final databaseReference = FirebaseDatabase.instance.reference();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    controller = new TextEditingController();
  }

  init() async {
    position = await Geolocator().getCurrentPosition();
    setState(() {
      currentlocation["latitude"] = position.latitude;
      currentlocation["longitude"] = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          elevation: 0.0,
          //leading: IconButton(icon: Icon(Icons.navigate_before,size: 35.0,),onPressed: ()=>Navigator.of(context).pop(),),
          title: Text(
            "Receiver",
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
                ))
          ],
        ),
        body: Stack(children: [
          new Column(children: <Widget>[
            new Container(
              height: 50.0,
              color: Colors.orangeAccent,
            ),
            new Expanded(
              child: new Container(
                child: currentlocation.isEmpty
                    ? new Center(child: CircularProgressIndicator())
                    : new Stack(
                        children: <Widget>[
                          new Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: new GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(currentlocation["latitude"],
                                      currentlocation["longitude"]),
                                  zoom: 15.0),
                              onMapCreated: _onMapCreated,
                            ),
                          ),
                        ],
                      ),
              ),
            )
          ]),
          new Container(
            child: new Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        title: Text(
                          source,
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        ),
                        leading: Icon(Icons.location_on),
                        onTap: () async {
                          var response = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchView()),
                          );
                          source = response["loc"];
                          globals.receiverLocationAddress = response["loc"];
                          setState(() {});
//                          mapController.addMarker(MarkerOptions(position: LatLng(response["lat"], response["long"]),
//                              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)));

                          globals.receiverLocationLatitude = response["lat"];
                          globals.receiverLocationLongitude = response["long"];
                          globals.receiverPhotoURL = fbuser.photoUrl;

                        }),
                    ListTile(
                        title: Text(
                          destination,
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        ),
                        leading: Icon(Icons.location_on),
                        onTap: () async {
                          var response = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchView()),
                          );
                          destination = response["loc"];
                          globals.receiverDestinationAddress = response["loc"];
                          setState(() {});
//                          mapController.addMarker(MarkerOptions(position: LatLng(response["lat"], response["long"]),
//                              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));

                          globals.receiverDestinationLatitude = response["lat"];
                          globals.receiverDestinationLongitude =
                              response["long"];
                        }),
                  ],
                ),
              ),
            ),
          ),
          new Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                width: 250.0,
                height: 45.0,
                child: new RaisedButton(
                  onPressed: () {
                    registerReceiver();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfirmReceiver(userId: globals.receiverEmail.replaceAll(".", ""))),
                    );
                  },
                  splashColor: Colors.red.withAlpha(700),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70.0)),
                  color: Colors.orangeAccent.withAlpha(700),
                  child: Text(
                    "Set Location",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ]));
  }

  void registerReceiver() {
    String userId = globals.receiverEmail;
    userId = userId.replaceAll(".", "");

    databaseReference.child("receiver").child(userId).set({
      'receiver_name': globals.receiverName,
      'receiver_email': globals.receiverEmailReal,
      'my_location_latitude': globals.receiverLocationLatitude,
      'my_location_longitude': globals.receiverLocationLongitude,
      'destination_latitude': globals.receiverDestinationLatitude,
      'destination_longitude': globals.receiverDestinationLongitude,
      'receiver_location_address': globals.receiverLocationAddress,
      'receiver_destination_address': globals.receiverDestinationAddress,
      'imageURL': globals.receiverPhotoURL,
      'receiver_status': "Your location is live on the map please wait untill a host accepts you.",
      'accepted_host': "",
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
//      mapController.addMarker(MarkerOptions(
//          position:
//          LatLng(currentlocation["latitude"], currentlocation["longitude"]),
//          infoWindowText: InfoWindowText("you are here", ""),
//          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//
//          visible: true));
    });
  }

  void gotocurrent() {
    mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(currentlocation["latitude"], currentlocation["longitude"])));
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
    // TODO: implement initState
    super.initState();
    getUser();
    globals.receiverPhotoURL = fbuser.photoUrl;
  }

  Future getUser() async {
    user = await _auth.currentUser();
    fbuser = user;
    setState(() {});
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
            leading: Image.asset("Assets/down.png",
                height: 30, width: 30, color: Colors.black),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ReceiverView()),
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
            leading: Image.asset("Assets/up.png",
                height: 30, width: 30, color: Colors.black),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Firstlogin()),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              "Settings",
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
                MaterialPageRoute(builder: (context) => Settings()),
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
            "Assets/ajce.png",
            height: 80.0,
            width: 80.0,
          )
        ],
      ),
    );
  }
}
