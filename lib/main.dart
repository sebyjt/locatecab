import 'package:flutter/material.dart';
void main()
{
  runApp(MaterialApp(
    home: Splash(),
    debugShowCheckedModeBanner: false,
  ));
}
class Splash  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: Color(0xffffd500),
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

                    ),))
            ],
          ),
        )
      ),
    );
  }
}
