import 'package:bookdoc/Services/Firebase/FirebaseAuth.dart';
import 'package:bookdoc/Services/Firebase/UserData.dart';
import 'package:bookdoc/Services/Providers/PermsProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  final userDocRef;
  const SettingsPage({super.key, required this.userDocRef});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.userDocRef.snapshots(), // Listen to changes in the document
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Show loading indicator
        }

        final userData = snapshot.data;

        List<CustomListTile> listItems = [
          CustomListTile(
            icon: Icons.crop_rotate,
            title: 'Flip Detection',
            trailing: Switch(
              onChanged: (bool? value) {
                widget.userDocRef.update({
                  'flipDetectionEnabled': !userData?['flipDetectionEnabled'],
                });
              },
              value: userData?['flipDetectionEnabled'],
            ),
            onTap: () {
              widget.userDocRef.update({
                'flipDetectionEnabled': !userData?['flipDetectionEnabled'],
              });
            },
          ),
          CustomListTile(
            icon: Icons.phone_android,
            title: 'Shake Detection',
            trailing: Switch(
              onChanged: (bool? value) {
                widget.userDocRef.update({
                  'shakeDetectionEnabled': !userData?['shakeDetectionEnabled'],
                });
              },
              value: userData?['shakeDetectionEnabled'],
            ),
            onTap: () {
              widget.userDocRef.update({
                'shakeDetectionEnabled': !userData?['shakeDetectionEnabled'],
              });
            },
          ),
          CustomListTile(
            icon: Icons.camera_alt,
            title: 'Webcam',
            trailing: Switch(
              onChanged: (bool? value) {
                widget.userDocRef.update({
                  'webcamEnabled': !userData?['webcamEnabled'],
                });
              },
              value: userData?['webcamEnabled'],
            ),
            onTap: () {
              widget.userDocRef.update({
                'webcamEnabled': !userData?['webcamEnabled'],
              });
            },
          ),
          CustomListTile(
            icon: Icons.location_on,
            title: 'Gps',
            trailing: Switch(
              onChanged: (bool? value) {
                widget.userDocRef.update({
                  'gpsEnabled': !userData?['gpsEnabled'],
                });
              },
              value: userData?['gpsEnabled'],
            ),
            onTap: () {
              widget.userDocRef.update({
                'gpsEnabled': !userData?['gpsEnabled'],
              });
            },
          ),
          CustomListTile(
            icon: Icons.wifi,
            title: 'RFID',
            trailing: Switch(
              onChanged: (bool? value) {
                widget.userDocRef.update({
                  'rfidEnabled': !userData?['rfidEnabled'],
                });
              },
              value: userData?['rfidEnabled'],
            ),
            onTap: () {
              widget.userDocRef.update({
                'rfidEnabled': !userData?['rfidEnabled'],
              });
            },
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text("Settings"),
          ),
          body: Column(
            children: [
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: listItems,
              ),
              OutlinedButton(
                onPressed: () {
                  signOut();
                  Navigator.pop(context);
                },
                child: Text("Logout"),
              )
            ],
          ),
        );
      },
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const CustomListTile({
    this.trailing,
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.symmetric(vertical: 0.4),
        child: ListTile(
          style: ListTileStyle.list,
          leading: Icon(icon),
          title: Text(title),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
