import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';




class HostDetails extends StatefulWidget {
  String acceptedHost;
  HostDetails(this.acceptedHost);

  @override
  _HostDetails createState() => _HostDetails();
}

class _HostDetails extends State<HostDetails> {
  var data = {};
  final databaseReference = FirebaseDatabase.instance.reference();

  String hostName;
  String hostEmail;
  String mobileNo;
  String model;
  String capacity;

  @override
  void initState() {
    databaseReference.child("host").child(widget.acceptedHost).once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      data=values;
      //print(values);
      print(data['mobile_no']);
      hostName = data['host_name'];
      hostEmail = data['host_email'];
      mobileNo = data['mobile_no'];
      model = data['model'];
      capacity = data['capacity'];
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

    );
  }
}