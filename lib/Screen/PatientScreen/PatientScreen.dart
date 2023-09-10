import 'package:bookdoc/Services/Firebase/FirebaseAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:bookdoc/Services/Firebase/UserData.dart";

class PatientScreen extends StatelessWidget {
  final userData;
  String uid;

  PatientScreen({super.key, required this.userData, required this.uid});

  @override
  Widget build(BuildContext context) {
    Patient thisPatient = Patient(
        age: userData['age'],
        userName: userData['userName'],
        appointments: userData['appointments'],
        avatar: userData['avatar'],
        uid: uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text("BookDoc"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PatientCard(thisPatient: thisPatient),
              const Text(
                "All Doctors ",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              DoctorCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final Patient thisPatient;

  PatientCard({required this.thisPatient});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      elevation: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 80, // Adjust the width as needed
                height: 80, // Adjust the height as needed
                child: Image.network(
                  thisPatient.avatar!,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(thisPatient.userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20)),
                  Text(
                    "Age: ${thisPatient.age}",
                    style: TextStyle(color: Colors.grey[500]),
                  )
                ],
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  DoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Doctor')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            print(documents[1]['userName']);

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: documents
                      .map((doc) => Card(
                            elevation:
                                3, // Adjust the card's elevation as needed
                            margin: const EdgeInsets.all(
                                10), // Margin around the card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Rounded corners for the card
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  16), // Padding inside the card
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Display patient's avatar (profile picture)
                                  CircleAvatar(
                                    radius:
                                        40, // Adjust the size of the avatar as needed
                                    backgroundImage:
                                        NetworkImage(doc['avatar']),
                                  ),
                                  const SizedBox(height: 10), // Spacer
                                  Text(
                                    doc['userName'],
                                    style: const TextStyle(
                                      fontSize:
                                          18, // Adjust the font size as needed
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5), // Spacer
                                  Text(
                                    'Age: ${doc['age']}',
                                    style: const TextStyle(
                                        fontSize:
                                            16), // Adjust the font size as needed
                                  ),
                                  const SizedBox(height: 10), // Spacer
                                  Text(
                                    'Specialised At : ${doc['specialisedAt'].toString()}',
                                    style: const TextStyle(
                                        fontSize:
                                            16), // Adjust the font size as needed
                                  ),
                                  const SizedBox(height: 10), // Spacer
                                  Text(
                                    'is Available : ${doc['isDoctorAvailable'] ? "Yes" : "No"}',
                                    style: const TextStyle(
                                        fontSize:
                                            16), // Adjust the font size as needed
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList()),
            );
          }

          return const Text("No Doctors Available");
        });
  }
}
