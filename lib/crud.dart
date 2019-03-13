import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
   Future<void> addDataU(UserData) async {
    Firestore.instance.collection('users').add(UserData);
  }

   Future<void> addDataH(UserData) async {
     Firestore.instance.collection('hosts').add(UserData);
   }

   Future<void> addDataR(UserData) async {
     Firestore.instance.collection('receiver').add(UserData);
   }
}
