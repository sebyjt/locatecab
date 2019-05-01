import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locatecab/about_page.dart';
import 'package:locatecab/get_host_details.dart';
import 'package:locatecab/receiver_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'dart:async';

import 'globals.dart' as globals;


class Accepted extends StatefulWidget {
//  String mob_no, capacity, model;
//  Landing(this.mob_no, this.capacity, this.model);

  @override
  _AcceptedState createState() => _AcceptedState();

}

class _AcceptedState extends State<Accepted> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  var data = [];


  GlobalKey<ScaffoldState> key = new GlobalKey();


  Future getUser() async {
    user = await _auth.currentUser();
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    getdata();
  }

getdata() async{
  await getUser();

  await getReceivers();
}
  getReceivers() async {
    data.clear();
   await databaseReference.child("receiver").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if((values as Map).containsKey("accepted_host") )
     {
       var mail=user.email;
       if(values["accepted_host"]==mail.replaceAll(".", ""))
        data.add(values);}

      });
    });
    print(data);
    setState(() {

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
            "Accepted Receivers",
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
                    onPressed: () async{
                     await getReceivers();
                    }))
          ],
        ),
        body: ListView.builder(itemBuilder: (context,i)=>Card(
          elevation: 5.0,
          child: ExpansionTile(leading: ClipOval(child: Image.network(data[i]["imageURL"],height: 50.0,width: 50.0,)),
              title: Text(data[i]["receiver_name"]),
            trailing: null,
              children: <Widget>[
                Text(data[i]["receiver_email"]),
                Text(data[i]["receiver_location_address"]),
                Text(data[i]["receiver_destination_address"]),
            ],
          ),
        ),itemCount: data.length,));
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
            leading: Image.asset("assets/images/up.png",
                height: 30, width: 30, color: Colors.black),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GetHostDetails()),
              );
            },
          ),
          ListTile(
            title: Text(
              "Accepted",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000)),
            ),
            leading: Icon(
              Icons.people,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Accepted()),
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
