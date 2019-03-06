import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
   Future<void> addData(UserData) async {
    Firestore.instance.collection('users').add(UserData);
  }
}
