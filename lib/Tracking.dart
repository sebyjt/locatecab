import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:locatecab/receiver_view.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
class Tracking extends StatefulWidget {
  bool trackHost;
  String acceptedHost;
  Tracking(this.trackHost,this.acceptedHost);
  @override
  _TrackingState createState() => _TrackingState(trackHost,acceptedHost);
}

class _TrackingState extends State<Tracking> {
  bool trackHost;
  String acceptedHost;
  _TrackingState(this.trackHost, this.acceptedHost);

  Set<Marker> markerlist = new Set();
  int mid;
  GlobalKey<ScaffoldState> key = new GlobalKey();

  GoogleMapController mapController;
  var source = "My Location", destination = "Destination";
  var currentlocation = {};
  Position position;
  TextEditingController controller;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  final databaseReference = FirebaseDatabase.instance.reference();

  Map<String, double> currentLocation = new Map();
  StreamSubscription subscription;


  @override
  void initState() {
    init();
    controller = new TextEditingController();

    if(trackHost){
      mid = 0;
      trackHostFunction();
    }

    super.initState();
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    unsubscribe();
  }
  unsubscribe() async{
    await subscription.cancel();

  }
  void trackHostFunction(){
      //getUser();
      //String userId = user.email;
      //userId = userId.replaceAll(".", "");
      subscription = FirebaseDatabase.instance
          .reference()
          .child("host")
          .child(acceptedHost)
          .onValue
          .listen((event) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(event.snapshot.value['host_location_latitude'], event.snapshot.value['host_location_longitude']), zoom:17),
          ),
        );
        Marker marker = new Marker(
          icon: BitmapDescriptor.fromAsset("assets/images/car_icon.png"),

          markerId: MarkerId("marker_id_"+mid.toString()),
          position: LatLng(event.snapshot.value['host_location_latitude'],
              event.snapshot.value['host_location_longitude']),
        );
        print(markerlist);
        markerlist.clear();
        setState(() {

        });
        markerlist.add(marker);
        mid++;
        setState(() {});
      });
  }

  Future getUser() async {
    user = await _auth.currentUser();

  }

  init() async {
    getUser();
    position = await Geolocator().getCurrentPosition();
    setState(() {
      currentlocation["latitude"] = position.latitude;
      currentlocation["longitude"] = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){},
      child: Scaffold(

          appBar: AppBar(
            automaticallyImplyLeading: false,
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
          ),
          key: key,
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

            new Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  width: 250.0,
                  height: 45.0,
                  child: new RaisedButton(
                    onPressed: () async {
                      await databaseReference.child('receiver').child(user.email.replaceAll(".", "")).remove();

                      await subscription.cancel();
                      SharedPreferences prefs= await SharedPreferences.getInstance();

                      await prefs.remove(user.email);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReceiverView()),
                      );
                    },
                    splashColor: Colors.red.withAlpha(700),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(70.0)),
                    color: Colors.orangeAccent.withAlpha(700),
                    child: Text(
                      "Picked Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ])),
    );
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

