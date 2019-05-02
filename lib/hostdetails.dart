import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:locatecab/Tracking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'receiver_view.dart';
import 'package:url_launcher/url_launcher.dart';

class HostDetails extends StatefulWidget {
  String acceptedHost,email;
  HostDetails(this.acceptedHost,this.email);

  @override
  _HostDetails createState() => _HostDetails(acceptedHost);
}

class _HostDetails extends State<HostDetails> {
  String acceptedHost;
  _HostDetails(this.acceptedHost);
  var data = {};
  final databaseReference = FirebaseDatabase.instance.reference();
 bool live=false;
  String hostName;
  String hostEmail;
  String mobileNo;
  String model;
  String capacity;
  String colour;
  String regNo;
  int flag=0;
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    print(live);
    trackHostFunction();
    databaseReference.child("host").child(widget.acceptedHost).once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      data=values;
      //print(values);
      print (data);
      print(data['mobile_no']);
      hostName = data['host_name'];
      hostEmail = data['host_email'];
      mobileNo = data['mobile_no'];
      model = data['model'];
      capacity = data['capacity'];
      colour = data['car_colour'];
      regNo = data['reg_no'];
      print(model);
      setState(() {

      });
    });

  }

  void trackHostFunction(){
    int i=0;
    //getUser();
    //String userId = user.email;
    //userId = userId.replaceAll(".", "");
    subscription = FirebaseDatabase.instance
        .reference()
        .child("host")
        .child(acceptedHost)
        .onValue
        .listen((event) {
i++;
if(i>1)
      live=true;
      print(live);
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context){
    print (widget.acceptedHost);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Details',style: TextStyle(
            color: Colors.white,fontFamily: 'Gothic',
            fontWeight:FontWeight.bold
        ),
        ),
        backgroundColor: Colors.orangeAccent,
        centerTitle:true,
        elevation: 0.0,
      ),
      body: Container(
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
                          new NetworkImage(data["imageURL"]!=null?data["imageURL"]:" ")))),
              Padding(padding: EdgeInsets.all(5)),
              Text(hostName!=null?hostName:" "),
              Padding(padding: EdgeInsets.all(5)),
              GestureDetector(
                onTap: () async{
                  String url = 'tel:'+mobileNo;
                  if (await canLaunch(url)) {
                    await launch(Uri.encodeFull(url));
                  } else {
                    throw 'Could not launch $url';
                  }

                },
                child: Text(mobileNo!=null?mobileNo:" ", style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue)),
              ),
              Padding(padding: EdgeInsets.all(5)),
              GestureDetector(
                onTap: () async{

                    String url = 'mailto:'+hostEmail;
                    if (await canLaunch(url)) {
                      await launch(Uri.encodeFull(url));
                    } else {
                      throw 'Could not launch $url';
                    }

                },
                child: Text(hostEmail!=null?hostEmail:" ",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue)),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 65,
                    width: 100,
                    child: Text("Car Model :"),
                  ),
                  SizedBox(
                    height: 65,
                    width: 200,
                    child: Text(model!=null?model:" "),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 65,
                    width: 100,
                    child: Text("Capacity :"),
                  ),
                  SizedBox(
                    height: 65,
                    width: 200,
                    child:
                    Text(capacity!=null?capacity:" "),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 65,
                    width: 100,
                    child: Text("Colour :"),
                  ),
                  SizedBox(
                    height: 65,
                    width: 200,
                    child:
                    Text(colour!=null?colour:" "),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 65,
                    width: 100,
                    child: Text("Registration No :"),
                  ),
                  SizedBox(
                    height: 65,
                    width: 200,
                    child:
                    Text(regNo!=null?regNo:" "),
                  ),
                ],
              ),
              RaisedButton(
                onPressed:live? () async{
                  SharedPreferences prefs= await SharedPreferences.getInstance();

                  await prefs.setString(widget.email, acceptedHost);
                  Navigator.push(
                    context,
                    MaterialPageRoute(

                        builder: (context) => Tracking(true,acceptedHost)),
                  );
                }:null,
                splashColor: Colors.red.withAlpha(700),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70.0)),
                color: Colors.orangeAccent.withAlpha(700),
                child: Text(
                  "Get Host's live location",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}