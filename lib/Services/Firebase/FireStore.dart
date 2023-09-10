import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'UserData.dart';

Future<void> CreateUser(UserCredential user, String role, String name) async {
  final userUid = user?.user?.uid;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  if (role == "Doctor") {
    final doctor = Doctor(
      uid: userUid!,
      userName: name,
      age: 40,
      specialisedAt: ["Physiology"],
      hospitalName: "",
      isDoctorAvailable: false,
      avatar:
          "https://previews.123rf.com/images/indomercy/indomercy1501/indomercy150100019/35500150-doctor-cartoon-illustration.jpg",
      webcamEnabled: true,
      gpsEnabled: true,
      flipDetectionEnabled: true,
      rfidEnabled: true,
      shakeDetectionEnabled: true,
    );
    await usersCollection.doc(userUid).set({
      'userName': doctor.userName,
      "age": doctor.age,
      "role": role,
      "specialisedAt": doctor.specialisedAt,
      "hospitalName": doctor.hospitalName,
      "avatar": doctor.avatar,
      'webcamEnabled': doctor.webcamEnabled,
      // Add any user-specific data fields here
      'gpsEnabled': doctor.gpsEnabled,
      "flipDetectionEnabled": doctor.flipDetectionEnabled,
      "rfidEnabled": doctor.rfidEnabled,
      "shakeDetectionEnabled": doctor.shakeDetectionEnabled,
      "isDoctorAvailable": doctor.isDoctorAvailable,
    });
  } else if (role == "Patient") {
    final patient = Patient(uid: userUid!,avatar: "https://cdn.pixabay.com/photo/2018/08/04/10/23/man-3583424_1280.jpg", userName: name, age: 20);
    await usersCollection.doc(userUid).set({
      'userName': patient.userName,
      "age": patient.age,
      "role": role,

      "avatar": patient.avatar,
      'appointments': patient.appointments
    });
  }
}
