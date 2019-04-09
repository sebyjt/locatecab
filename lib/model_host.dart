import 'package:firebase_database/firebase_database.dart';

class ModelHost{
  String _id;

  String _hostName;
  String _hostEmail;
  String _mobileNo;
  String _model;
  String _capacity;

//  double _myLocationLatitude;
//  double _myLocationLongitude;
//  double _destinationLatitude;
//  double _destinationLongitude;
//
//  String _hostLocationAddress;
//  String _hostDestinationAddress;
//
//  String _hostStatus;

//  ModelHost(this._hostName, this._hostEmail, this._myLocationLatitude, this._myLocationLongitude,
//      this._destinationLatitude, this._destinationLongitude,
//      this._hostLocationAddress, this._hostDestinationAddress, this._hostStatus);

  ModelHost.map(dynamic obj) {
    this._id = obj['id'];
    this._hostName = obj['host_name'];
    this._hostEmail = obj['host_email'];
    this._mobileNo = obj['mobile_no'];
    this._model = obj['model'];
    this._capacity = obj ['capacity'];
//    this._myLocationLatitude = obj['my_location_latitude'];
//    this._myLocationLongitude = obj['my_location_longitude'];
//    this._destinationLatitude = obj['destination_latitude'];
//    this._destinationLongitude = obj['destination_longitude'];
//    this._hostLocationAddress = obj['host_location_address'];
//    this._hostDestinationAddress = obj['host_destination_address'];
//    this._hostStatus = obj['host_status'];
  }

  String get hostName => _hostName;
  String get hostEmail => _hostEmail;
  String get mobile_no => _mobileNo;
  String get model => _model;
  String get capacity => _capacity;
//  double get myLocationLatitude => _myLocationLatitude;
//  double get myLocationLongitude => _myLocationLongitude;
//  double get destinationLatitude => _destinationLatitude;
//  double get destinationLongitude => _destinationLongitude;
//  String get hostLocationAddress => _hostLocationAddress;
//  String get hostDestinationAddress => _hostDestinationAddress;
//  String get hostStatus => _hostStatus;

  ModelHost.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _hostName = snapshot.value['host_name'];
    _hostEmail = snapshot.value['host_email'];
    _mobileNo = snapshot.value['mobile_no'];
    _model = snapshot.value['model'];
    _capacity = snapshot.value['capacity'];
//    _myLocationLatitude = snapshot.value['my_location_latitude'];
//    _myLocationLongitude = snapshot.value['my_location_longitude'];
//    _destinationLatitude = snapshot.value['destination_latitude'];
//    _destinationLongitude = snapshot.value['destination_longitude'];
//    _hostLocationAddress = snapshot.value['host_location_address'];
//    _hostDestinationAddress = snapshot.value['host_destination_address'];
//    _hostStatus = snapshot.value['host_status'];

  }
}