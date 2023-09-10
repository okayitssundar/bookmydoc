import 'package:flutter/material.dart';

class PermsProvider extends ChangeNotifier {

  bool _webcamEnabled = false;
  bool _proximityGyroEnabled = false;
  bool _gpsEnabled =false;
  bool _accelerometer = false;
  bool _rfid = false;
  bool get isWebcamEnabled => _webcamEnabled;
  bool get isFlipDetectionEnabled => _proximityGyroEnabled;
  bool get isGpsEnabled => _gpsEnabled;
  bool get isShakeDetectionEnabled => _accelerometer;
  bool get isRfidEnabled => _rfid;



  // Constructor
  Future<void> togglewebcam() async {
    _webcamEnabled = !_webcamEnabled;
    notifyListeners();
  }
  Future<void> toggleShakeDetection() async {
    _accelerometer = !_accelerometer;
    notifyListeners();
  }
  Future<void> toggleGps() async {
    _gpsEnabled = !_gpsEnabled;
    notifyListeners();
  }
  Future<void> toggleFlipDetection() async {
    _proximityGyroEnabled = !_proximityGyroEnabled;
    notifyListeners();
  }
  Future<void> toggleRfidDetection() async {
    _rfid = !_rfid;
    notifyListeners();
  }

// Authentication methods (sign up, sign in, sign out) can be added here.
}
