import 'package:bookdoc/Screen/AuthScreen/AuthScreen.dart';
import 'package:bookdoc/Screen/DoctorScreen/DoctorScreen.dart';
import 'package:bookdoc/Services/Firebase/FireStore.dart';
import 'package:bookdoc/Services/Providers/AuthProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'PatientScreen/PatientScreen.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user != null) {
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final userData = snapshot.data;

            if (userData != null && userData.exists) {
              final role = userData['role'] as String?;

              if (role == "Patient") {
                return  PatientScreen(userData:userData,uid: user.uid,);
              } else if (role == "Doctor") {
                return  DoctorScreen(userData:userData,uid: user.uid,);
              }
            }
          }

          // Return a loading indicator or default widget while fetching the role.
          return Scaffold(
              body: const Center(child: CircularProgressIndicator()));
        },
      );
    } else {
      // User is not authenticated, show login/register UI.
      return const AuthScreen();
    }
  }
}
