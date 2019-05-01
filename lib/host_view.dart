import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locatecab/about_page.dart';
import 'package:locatecab/get_host_details.dart';
import 'package:locatecab/search_view.dart';
import 'package:locatecab/receiver_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'dart:async';

import 'globals.dart' as globals;


class HostView extends StatefulWidget {
//  String mob_no, capacity, model;
//  Landing(this.mob_no, this.capacity, this.model);

  @override
  _HostViewState createState() => _HostViewState();

}

class _HostViewState extends State<HostView> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  final databaseReference = FirebaseDatabase.instance.reference();
  Set<Marker> markerlist = new Set();
  var data = [];

  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubcription;
  Location location = new Location();

  GoogleMapController mapController;
  var map = <String, String>{};

  GlobalKey<ScaffoldState> key = new GlobalKey();


  var source = "My Location", destination = "Destination";
  var currentlocation = {};
  Position position;
  TextEditingController controller;

  Future getUser() async {
    user = await _auth.currentUser();
    setState(() {});
  }

  void notifyReceiver(var data) async{
    await getUser();
    String userId = data['receiver_email'].replaceAll(".", "");

    databaseReference.child("receiver").child(userId).set({
      'receiver_name': data['receiver_name'],
      'receiver_email': data['receiver_email'],
      'my_location_latitude': data['my_location_latitude'],
      'my_location_longitude': data['my_location_longitude'],
      'destination_latitude': data['destination_latitude'],
      'destination_longitude': data['destination_longitude'],
      'receiver_location_address': data['receiver_location_address'],
      'receiver_destination_address': data['receiver_destination_address'],
      'imageURL': data['imageURL'],
      'receiver_status': "You are accepted by "+user.displayName,
      'accepted_host': user.email.replaceAll(".", ""),
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    controller = new TextEditingController();

    locationSubcription = location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        currentLocation = result;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    currentLocation['latitude'], currentLocation['longitude']),
                zoom: 13),
          ),
        );
        /*mapController.addMarker(
          MarkerOptions(
            position: LatLng(currentLocation['latitude'], currentLocation['longitude']),
              infoWindowText: InfoWindowText("You are here", "Find receivers around you"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
          ),
        );*/
      });
      updateHostLocation(currentLocation['latitude'], currentLocation['longitude']);
    });

    databaseReference.child("receiver").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        data.add(values);
        print(values);
        Marker marker = new Marker(
            markerId: MarkerId(values["receiver_email"]),
            position: LatLng(values['my_location_latitude'],
                values['my_location_longitude']),
            onTap: () => _onMarkerTapped(MarkerId(values["receiver_email"])));
        markerlist.add(marker);
        setState(() {});
        //mapController.onMarkerTapped.add(_onMarkerTapped);
      });
    });
  }

  void _onMarkerTapped(MarkerId markerid) {
    var selectedMarker = markerid.value;
    print(markerid.value);
    _BottomSheet(context, selectedMarker);
  }

  void _BottomSheet(context, var marker) {
    int index;
    for (int i = 0; i < data.length; i++) {
      if (data[i]["receiver_email"] == marker) index = i;
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 30.0, top: 10.0, right: 30.0, bottom: 1.0),
              child: Column(
                children: <Widget>[
                  Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  new NetworkImage(data[index]["imageURL"])))),
                  Padding(padding: EdgeInsets.all(5)),
                  Text(data[index]["receiver_name"]),
                  Padding(padding: EdgeInsets.all(5)),
                  GestureDetector(
                      child: Text(data[index]["receiver_email"],
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue)),
                      onTap: () {
                        _launchURL(data[index]["receiver_email"]);
                      }),
                  Padding(padding: EdgeInsets.all(5)),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 65,
                        width: 100,
                        child: Text("Pick up Location :"),
                      ),
                      SizedBox(
                        height: 65,
                        width: 200,
                        child: Text(data[index]["receiver_location_address"]),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 65,
                        width: 100,
                        child: Text("Destination :"),
                      ),
                      SizedBox(
                        height: 65,
                        width: 200,
                        child:
                            Text(data[index]["receiver_destination_address"]),
                      ),
                    ],
                  ),
                  RaisedButton(
                      child: new Text("Accept receiver"),
                      color: Colors.orangeAccent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      onPressed: ()=> notifyReceiver(data[index]))
                ],
              ),
            ),
          );
        });
  }

  _launchURL(String mailId) async {
    String url = 'mailto:'+mailId;
    if (await canLaunch(url)) {
      await launch(Uri.encodeFull(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  init() async {
    user = await _auth.currentUser();
    position = await Geolocator().getCurrentPosition();
    setState(() {
      currentlocation["latitude"] = position.latitude;
      currentlocation["longitude"] = position.longitude;
      globals.hostLocationLatitude = position.latitude;
      globals.hostLocationLongitude = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          elevation: 0.0,
          //leading: IconButton(icon: Icon(Icons.navigate_before,size: 35.0,),onPressed: ()=>Navigator.of(context).pop(),),
          title: Text(
            "Host",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Gothic',
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                    icon: new Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HostView()),
                      );
                    }))
          ],
        ),
        body: Stack(children: [
          new Column(children: <Widget>[
            new Container(
              padding: EdgeInsets.only(bottom: 10),
              height: 30.0,
              color: Colors.orangeAccent,
              child: new SizedBox.expand(
                child: Center(
                  child: Text("Tap on markers for receiver detials",
                    style: TextStyle(
                        color: Colors.white,fontFamily: 'Gothic',
                    ),
                  ),
                ),
              ),
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
                              markers: markerlist,
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
            child: new Card(),
          ),
        ]));
  }

  void updateHostLocation(double latitude, double longitude) {
    String userId = user.email;
    userId = userId.replaceAll(".", "");

    databaseReference.child("host").child(userId).set({
      'host_name': user.displayName,
      'host_email': user.email,
      'mobile_no' : globals.mobileNo,
      'model' : globals.model,
      'capacity' : globals.capacity,
      'host_location_latitude': latitude,
      'host_location_longitude': longitude,
      'imageURL':globals.receiverPhotoURL,
      'reg_no': globals.regNo,
      'car_colour': globals.carColour,
    });
  }

  void registerHost() async {
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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      /*mapController.addMarker(MarkerOptions(
          position: LatLng(currentlocation["latitude"], currentlocation["longitude"]),
          infoWindowText: InfoWindowText("you are here", ""),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          visible: true));*/
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
