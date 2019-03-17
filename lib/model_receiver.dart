import 'package:firebase_database/firebase_database.dart';

class ModelReceiver{
  String _id;
  double _myLocationLatitude;
  double _myLocationLongitude;
  double _destinationLatitude;
  double _destinationLongitude;

  ModelReceiver(this._myLocationLatitude, this._myLocationLongitude,
      this._destinationLatitude, this._destinationLongitude);

  ModelReceiver.map(dynamic obj) {
    this._id = obj['id'];
    this._myLocationLatitude = obj['my_location_latitude'];
    this._myLocationLongitude = obj['my_location_longitude'];
    this._destinationLatitude = obj['destination_latitude'];
    this._destinationLongitude = obj['destination_longitude'];
  }

  double get myLocationLatitude => _myLocationLatitude;
  double get myLocationLongitude => _myLocationLongitude;
  double get destinationLatitude => _destinationLatitude;
  double get destinationLongitude => _destinationLongitude;

  ModelReceiver.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _myLocationLatitude = snapshot.value['my_location_latitude'];
    _myLocationLongitude = snapshot.value['my_location_longitude'];
    _destinationLatitude = snapshot.value['destination_latitude'];
    _destinationLongitude = snapshot.value['destination_longitude'];
  }
}