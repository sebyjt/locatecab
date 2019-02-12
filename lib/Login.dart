import 'package:flutter/material.dart';
import 'Landing.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context){
  return Container(
 height: double.infinity,
  width: double.infinity,
  color: Colors.white,
  child: Center(child:new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Image.asset("Assets/logo.png",height: 100.0,width: 100.0,),
     new Padding(padding: EdgeInsets.only(top:50.0),child:  RaisedButton(
         color: Colors.orangeAccent,
         shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)) ,
         child: Text(""
             "Sign in with Amal Jyothi Mail",
           style: TextStyle(
               fontSize: 20.0,
               color: Colors.red
           ),
         ),
         onPressed: (){
           //action
           Navigator.push(context, MaterialPageRoute(builder: (context)=>new Landing()));
         }),)
    ],
  )



  ),
  );
  }
}
