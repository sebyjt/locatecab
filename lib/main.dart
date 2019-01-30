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
class Splash  extends StatelessWidget {
  Duration duration=const Duration(seconds: 5);
  @override
  Widget build(BuildContext context) {

    Timer(duration,(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>new Login()));
    }
    );
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: Color(0xffffa200),
        child:new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("Assets/logo.png",height: 100,width: 100,),
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                  child:Text("LocateCab Ajce",style:
                    TextStyle(
                      color: Color(0xfffd4a44),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold
                    ),))
            ],
          ),
        )
      ),
    );
  }
}
