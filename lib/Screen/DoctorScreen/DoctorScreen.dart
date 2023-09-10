import 'package:bookdoc/Services/Providers/PermsProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:bookdoc/Screen/DoctorScreen/Components/Settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:bookdoc/Services/Firebase/UserData.dart";

class DoctorScreen extends StatefulWidget {
  final userData;
  String uid;

  DoctorScreen({super.key, required this.userData, required this.uid});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  late ShakeDetector detector;
  late var userDocRef;

  @override
  void initState() {
    super.initState();
    userDocRef = FirebaseFirestore.instance.collection('users').doc(widget.uid);

    if (widget.userData["shakeDetectionEnabled"]) {
      detector = ShakeDetector.autoStart(
        onPhoneShake: () {
          userDocRef.update({
            'isDoctorAvailable': !widget.userData["isDoctorAvailable"],
          });
        },
      );
    }
  }

  @override
  void dispose() {
    if (widget.userData["shakeDetectionEnabled"]) detector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Doctor thisdoctor = Doctor(
        uid: widget.uid,
        userName: widget.userData['userName'],
        age: widget.userData['age'],
        specialisedAt: widget.userData["specialisedAt"],
        webcamEnabled: widget.userData["webcamEnabled"],
        gpsEnabled: widget.userData["gpsEnabled"],
        avatar: widget.userData["avatar"],
        hospitalName: widget.userData["hospitalName"],
        flipDetectionEnabled: widget.userData["flipDetectionEnabled"],
        shakeDetectionEnabled: widget.userData["shakeDetectionEnabled"],
        rfidEnabled: widget.userData["rfidEnabled"],
        isDoctorAvailable: widget.userData["isDoctorAvailable"]);

    String _calculateGreeting() {
      final hour = DateTime.now().hour;
      if (hour >= 0 && hour < 12) {
        return 'Good Morning';
      } else if (hour >= 12 && hour < 17) {
        return 'Good Afternoon';
      } else if (hour >= 17 && hour < 20) {
        return 'Good Evening';
      } else {
        return 'Good Night';
      }
    }

    final String greeting = _calculateGreeting();
    return Scaffold(
        appBar: AppBar(
          title: const Text("BookDoc"),
          backgroundColor:
              thisdoctor.isDoctorAvailable ? Colors.green : Colors.blueAccent,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SettingsPage(userDocRef: userDocRef)));
                },
                icon: const Icon(Icons.settings)),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "$greeting - ${thisdoctor.userName}",
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Are you available Now??",
                        style: const TextStyle(fontSize: 20)),
                    Switch(
                        value: thisdoctor.isDoctorAvailable,
                        onChanged: (val) {
                          userDocRef.update({
                            'isDoctorAvailable': !thisdoctor.isDoctorAvailable,
                          });
                        })
                  ],
                ),
                //TODO list of bookings
              ],
            ),
          ),
        ));
  }
}
