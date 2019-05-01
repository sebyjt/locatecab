import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: const Text('About',style: TextStyle(
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