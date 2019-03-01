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
              padding: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
              child: new Text(
                "Your Location is live on the Map\n"
                    "Please wait until a host accepts you\n",
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
                child: new RaisedButton(
                  splashColor: Colors.red.withAlpha(700),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70.0)),
                  color: Colors.orangeAccent.withAlpha(700),
                  child: Text(
                    "Done",
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
