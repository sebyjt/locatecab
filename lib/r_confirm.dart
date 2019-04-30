import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'hostdetails.dart';

class ConfirmReceiver extends StatefulWidget {
  String userId;
  ConfirmReceiver({Key key, @required this.userId}) : super(key: key);
  @override
  _ConfirmReceiverState createState() => _ConfirmReceiverState(userId);
}

class _ConfirmReceiverState extends State<ConfirmReceiver> {

  String receiverStatus, acceptedHost;
  int i=0;
  String userId;
  _ConfirmReceiverState(this.userId);

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    databaseReference.child("receiver").child(userId).child('receiver_status').onValue.listen((Event status){
      print(status.snapshot.value.toString());
      setState(() {
        receiverStatus = status.snapshot.value.toString();
      });
    });

    databaseReference.child("receiver").child(userId).child('accepted_host').onValue.listen((Event status){
      print(status.snapshot.value.toString());
      setState(() {
        acceptedHost = status.snapshot.value.toString();
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
              child: new Text(
                "Your Location is now live!",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: new Text(
                receiverStatus,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: new Image.asset('Assets/movingcar.gif',
                  alignment: Alignment.center),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Container(
                width: 250.0,
                height: 45.0,
                child: RaisedButton(
                  onPressed: acceptedHost != "null"? ()=>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HostDetails(acceptedHost)),
                    ):null
                  ,
                  splashColor: Colors.red.withAlpha(700),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70.0)),
                  color: Colors.orangeAccent.withAlpha(700),
                  child: Text(
                    "Get Host Details",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
