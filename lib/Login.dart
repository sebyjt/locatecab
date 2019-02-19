import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'Landing.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loadFlag=false;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print("cred " + googleUser.email);
    if (googleUser.email.contains("ajce.in") ||
        googleUser.email.contains("amaljyothi.ac.in")) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print("cred " + googleUser.email);

      final FirebaseUser user = await _auth.signInWithCredential(credential);
      print("signed in " + user.displayName);
      return user;
    } else {
      _googleSignIn.signOut();
      return null;
    }

  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();


  }
  Future getUser() async
  {
    user=await _auth.currentUser();
    if(user!=null)
    {
      
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>new Landing()));
    }
    setState(() {
      loadFlag=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Center(
            child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "Assets/logo.png",
              height: 100.0,
              width: 100.0,
            ),
            new Padding(
              padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
              child: RaisedButton(
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Image.asset(
                        "Assets/g.png",
                        height: 50.0,
                        width: 50.0,
                      ),
                      Text(
                          ""
                          "Sign in with Amal Jyothi Mail",
                          style: TextStyle(fontSize: 15.0, color: Colors.white))
                    ],
                  ),
                  onPressed:loadFlag==true? () {
                    //action

                    _handleSignIn().then((FirebaseUser user) {
                      if (user == null)
                        key.currentState.showSnackBar(SnackBar(
                            content:
                                Text("Sign in with Amal Jyothi Credentials")));
                      else {
                        key.currentState.showSnackBar(SnackBar(
                            content: Text("Signed in as " + user.displayName)));
                        var duration = const Duration(seconds: 2);
                        Timer(duration, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new Landing()));
                        });
                      }
                    }).catchError((e) => print(e));
                  }:null),
            )
          ],
        )),
      ),
    );
  }
}
