import 'package:firebase_database/firebase_database.dart';

class ModelHost{
  String _id;

  String _hostName;
  String _hostEmail;
  String _mobileNo;
  String _model;
  String _capacity;
  String _regNo;
  String _carColour;


  double _hostLocationLatitude;
  double _hostLocationLongitude;
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
    this._hostLocationLatitude = obj['my_location_latitude'];
    this._hostLocationLongitude = obj['my_location_longitude'];
    this._regNo = obj ['reg_no'];
    this._carColour = obj ['car_colour'];
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
  double get hostLocationLatitude => _hostLocationLatitude;
  double get hostLocationLongitude => _hostLocationLongitude;
  String get regNo =>_regNo;
  String get carColour => _carColour;
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
    _hostLocationLatitude = snapshot.value['host_location_latitude'];
    _hostLocationLongitude = snapshot.value['host_location_longitude'];
    _regNo = snapshot.value['reg_no'];
    _carColour = snapshot.value['car_colour'];
//    _destinationLatitude = snapshot.value['destination_latitude'];
//    _destinationLongitude = snapshot.value['destination_longitude'];
//    _hostLocationAddress = snapshot.value['host_location_address'];
//    _hostDestinationAddress = snapshot.value['host_destination_address'];
//    _hostStatus = snapshot.value['host_status'];

  }
}