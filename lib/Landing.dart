import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locatecab/settings_page.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle:true,
        elevation: 0.0,
        title:  Text("Mark my Location",style: TextStyle(
          color: Colors.white,fontFamily: 'Gothic',
          fontWeight:FontWeight.bold
        ),),
        
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(right: 10.0),child:
          Icon(Icons.person,color: Colors.white,)
          )
        ],

      ),
      body: new Column(
        children: <Widget>[
          new Container(
            height: 50.0,
            color: Colors.orangeAccent,

          ),
      new Expanded(child: MapsDemo(),)]));}

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}


class Drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.6,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(children: [new Image.asset("Assets/myava.jpg"),
          Positioned( bottom: 5.0,
                      child: Container(
                      
                        width: MediaQuery.of(context).size.width*.6,
                        alignment: Alignment.bottomCenter,child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Mareena Vathaloor",style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  background: Paint()..color=Colors.black.withAlpha(7777)
                ),),
                Text("mava@cs.ajce.in",style: TextStyle(
                  color: Colors.white,
                   background: Paint()..color=Colors.black.withAlpha(7777),
                  fontSize: 20.0)) 
              ],
            ),),
          )]),
          ListTile(
            title:  Text("Host", style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w400, color:  Color(0xff000000)),),
            leading: Image.asset("Assets/up.png", height: 30, width: 30,color: Colors.black),
          ),ListTile(
            title:  Text("Receiver", style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w400, color:  Color(0xff000000)),),
            leading: Image.asset("Assets/down.png", height: 30, width: 30,color: Colors.black),
          ),
          Divider(),
          ListTile(
            title:  Text("Settings", style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w400, color:  Color(0xff000000)),),
            leading: Icon(Icons.settings, color: Colors.black,),
            onTap:  () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),
          ListTile(
            title:  Text("Logout", style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w400, color:  Color(0xff000000)),),
            leading: Icon(Icons.power_settings_new, color: Colors.black,),
          ),
          Image.asset("Assets/ajce.png",height: 80.0,width: 80.0,)
        ],
      ),
    );
  }
}
class MapsDemo extends StatefulWidget {
  @override
  State createState() => MapsDemoState();
}

class MapsDemoState extends State<MapsDemo> {
  var currentlocation = {};
  GoogleMapController mapController;
  Position position;
  TextEditingController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    controller = new TextEditingController();
  }

  init() async {
    position = await Geolocator()
        .getCurrentPosition();
    setState(() {
      currentlocation["latitude"] = position.latitude;
      currentlocation["longitude"] = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
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
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      mapController.addMarker(MarkerOptions(
          position:
              LatLng(currentlocation["latitude"], currentlocation["longitude"]),
          infoWindowText: InfoWindowText("you are here", ""),
          visible: true));
    });
  }

  void gotocurrent() {
    mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(currentlocation["latitude"], currentlocation["longitude"])));
  }
}