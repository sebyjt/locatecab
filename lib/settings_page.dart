import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: const Text('Settings',style: TextStyle(
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