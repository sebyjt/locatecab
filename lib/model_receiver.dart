import 'package:firebase_database/firebase_database.dart';

class ModelReceiver{
  String _id;

  String _receiverName;
  String _receiverEmail;

  double _myLocationLatitude;
  double _myLocationLongitude;
  double _destinationLatitude;
  double _destinationLongitude;

  String _receiverLocationAddress;
  String _receiverDestinationAddress;

  String _receiverStatus;

  ModelReceiver(this._receiverName, this._receiverEmail, this._myLocationLatitude, this._myLocationLongitude,
      this._destinationLatitude, this._destinationLongitude,
      this._receiverLocationAddress, this._receiverDestinationAddress, this._receiverStatus);

  ModelReceiver.map(dynamic obj) {
    this._id = obj['id'];
    this._receiverName = obj['receiver_name'];
    this._receiverEmail = obj['receiver_email'];
    this._myLocationLatitude = obj['my_location_latitude'];
    this._myLocationLongitude = obj['my_location_longitude'];
    this._destinationLatitude = obj['destination_latitude'];
    this._destinationLongitude = obj['destination_longitude'];
    this._receiverLocationAddress = obj['receiver_location_address'];
    this._receiverDestinationAddress = obj['receiver_destination_address'];
    this._receiverStatus = obj['receiver_status'];
  }

  String get receiverName => _receiverName;
  String get receiverEmail => _receiverEmail;
  double get myLocationLatitude => _myLocationLatitude;
  double get myLocationLongitude => _myLocationLongitude;
  double get destinationLatitude => _destinationLatitude;
  double get destinationLongitude => _destinationLongitude;
  String get receiverLocationAddress => _receiverLocationAddress;
  String get receiverDestinationAddress => _receiverDestinationAddress;
  String get receiverStatus => _receiverStatus;

  ModelReceiver.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _receiverName = snapshot.value['receiver_name'];
    _receiverEmail = snapshot.value['receiver_email'];
    _myLocationLatitude = snapshot.value['my_location_latitude'];
    _myLocationLongitude = snapshot.value['my_location_longitude'];
    _destinationLatitude = snapshot.value['destination_latitude'];
    _destinationLongitude = snapshot.value['destination_longitude'];
    _receiverLocationAddress = snapshot.value['receiver_location_address'];
    _receiverDestinationAddress = snapshot.value['receiver_destination_address'];
    _receiverStatus = snapshot.value['receiver_status'];

  }
}