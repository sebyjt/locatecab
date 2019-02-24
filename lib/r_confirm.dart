import 'package:flutter/material.dart';

class ConfirmR extends StatefulWidget {
  @override
  _ConfirmRState createState() => _ConfirmRState();
}

class _ConfirmRState extends State<ConfirmR> {
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
              padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
              child: new Text(
                "Your Location is live on the Map\n"
                    "Please wait until a host accepts you",
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
