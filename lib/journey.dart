import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locatecab/about_page.dart';
import 'package:locatecab/accepted_receivers.dart';
import 'package:locatecab/get_host_details.dart';
import 'package:locatecab/host_view.dart';
import 'package:locatecab/receiver_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'dart:async';

import 'globals.dart' as globals;

import 'globals.dart' as globals;
class Journey extends StatefulWidget {
  @override
  _JourneyState createState() => _JourneyState();
}

class _JourneyState extends State<Journey> {
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
@override
  void dispose(){
    // TODO: implement dispose
    super.dispose();
    unsubscribe();
  }
unsubscribe() async{
  await locationSubcription.cancel();

}
  @override
  void initState() {
    super.initState();
    init();
    controller = new TextEditingController();


  }
  void getMarkers(){
    markerlist.clear();
   Marker marker = new Marker(
     icon: BitmapDescriptor.fromAsset("assets/images/car_icon.png"),

     markerId: MarkerId("self"),
        position: LatLng(currentLocation['latitude'],
            currentLocation['longitude']),);
   markerlist.add(marker);
    databaseReference.child("receiver").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        data.add(values);
        print(values);
        TimeOfDay timeOfDay=new TimeOfDay.now();
        print(timeOfDay.toString());
        if((values as Map).containsKey("accepted_host")&&values["accepted_host"]==user.email.replaceAll(".", ""))
        {
          Marker marker;


          if(timeOfDay.hour>=TimeOfDay(hour: 12, minute: 0).hour)
          {
            marker = new Marker(
                markerId: MarkerId(values["receiver_email"]),
                position: LatLng(values['destination_latitude'],
                    values['destination_longitude']),
                onTap: () => _onMarkerTapped(MarkerId(values["receiver_email"])));
          }
          else
          {
            marker = new Marker(
                markerId: MarkerId(values["receiver_email"]),
                position: LatLng(values['my_location_latitude'],
                    values['my_location_longitude']),
                onTap: () => _onMarkerTapped(MarkerId(values["receiver_email"])));}
          markerlist.add(marker);
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(
                      currentLocation['latitude']!=null?currentLocation['latitude']:0.0, currentLocation['longitude']!=null?currentLocation['longitude']:0.0),
                  zoom: 17),
            ),

          );
          setState(() {});}
        //mapController.onMarkerTapped.add(_onMarkerTapped);
      });
    });
    print(data);
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
    locationSubcription = location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        currentLocation = result;
        print(mapController);

        /*mapController.addMarker(
          MarkerOptions(
            position: LatLng(currentLocation['latitude'], currentLocation['longitude']),
              infoWindowText: InfoWindowText("You are here", "Find receivers around you"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
          ),
        );*/
      });
      getMarkers();

      updateHostLocation(currentLocation['latitude'], currentLocation['longitude']);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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

        ),
        body: Stack(children: [
          new Column(children: <Widget>[
            new Container(
              padding: EdgeInsets.only(bottom: 10),
              height: 30.0,
              color: Colors.orangeAccent,
              child: new SizedBox.expand(
                child: Center(
                  child: Text("Your journey has started",
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
                            zoom: 10.0),
                        onMapCreated: _onMapCreated,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
          new Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                width: 250.0,
                height: 45.0,
                child: new RaisedButton(

                  onPressed: () async {
                    await locationSubcription.cancel();
                    SharedPreferences prefs= await SharedPreferences.getInstance();

                    await prefs.remove(user.email);
                         Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HostView()),
                    );
                  },
                  splashColor: Colors.red.withAlpha(700),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70.0)),
                  color: Colors.orangeAccent.withAlpha(700),
                  child: Text(
                    "Stop Journey",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
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
