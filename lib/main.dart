import 'package:flutter/material.dart';
import 'dart:async';
import 'Login.dart';
void main()
{
  runApp(MaterialApp(
    home: Splash(),
    debugShowCheckedModeBanner: false,
  ));
}
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Duration duration=const Duration(seconds: 5);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(duration,(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>new Login()));
    }
    );
  }
  @override
  Widget build(BuildContext context) {

    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          height: height,
          width: width,
          color: Colors.white,
          child:new Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("Assets/logo.png",height: 100,width: 100,),
                Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child:Text("LocateCab AJCE",style:
                    TextStyle(
                        color: Color(0xfffd4a44),
                        fontSize: 22.0,
                        fontFamily: 'Gothic',
                        fontWeight: FontWeight.bold
                    ),))
              ],
            ),
          )
      ),
    );}
}
