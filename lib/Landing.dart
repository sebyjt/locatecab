import 'package:flutter/material.dart';
class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          drawer: Drawer(),
          appBar: AppBar(
            leading: GestureDetector(child:Icon(Icons.navigate_before),onTap:(){ Navigator.pop(context);},),
            backgroundColor: Colors.orangeAccent,
            centerTitle:true,
            elevation: 0.0,
            title:  Text("Mark my Location",style: TextStyle(
              color: Colors.white,fontFamily: 'Gothic',
              fontWeight:FontWeight.bold
            ),),
            
            actions: <Widget>[
              Padding(padding: EdgeInsets.only(right: 10.0),child:
              Icon(Icons.person,color: Colors.white,)
              )
            ],

          ),
        )
      ],
    );
  }
}
class Drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.6,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(children: [new Image.asset("Assets/myava.jpg"),
          Positioned( bottom: 5.0,
                      child: Container(
                      
                        width: MediaQuery.of(context).size.width*.6,
                        alignment: Alignment.bottomCenter,child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Mareena Vathaloor",style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  background: Paint()..color=Colors.black.withAlpha(7777)
                ),),
                Text("mava@cs.ajce.in",style: TextStyle(
                  color: Colors.white,
                   background: Paint()..color=Colors.black.withAlpha(7777),
                  fontSize: 20.0)) 
              ],
            ),),
          )]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
           
            Image.asset("Assets/up.png",height: 30.0,width: 50.0,color: Colors.black,),
            Text("Receiver")
          ],),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
           
            Image.asset("Assets/down.png",height: 30.0,width: 50.0,color: Colors.black,),
            Text("Receiver")
          ],),
          new Divider(),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
           
            Icon(Icons.settings),
            Text("Settings")
          ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
           
            Icon(Icons.power_settings_new),
            Text("Receiver")
          ],),
          new Image.asset("Assets/ajce.png",height: 80.0,width: 80.0,)
        ],
      ),
    );
  }
}
