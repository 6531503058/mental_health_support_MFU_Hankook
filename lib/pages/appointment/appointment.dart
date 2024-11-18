import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_support/pages/appointment/choosedTherapist.dart';
import 'package:mental_health_support/pages/appointment/myAppointment.dart';
import 'package:mental_health_support/pages/home/home.dart';
import 'package:mental_health_support/pages/home/splash.dart';
import 'package:mental_health_support/services/auth_service.dart';

class Appointment extends StatelessWidget {
  const Appointment({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('therapistFronts').snapshots(),
      builder: (ctx, therapistFrontSnapshots) {
        if (therapistFrontSnapshots.connectionState ==
            ConnectionState.waiting) {
          return const SplashHome();
        }
        if (!therapistFrontSnapshots.hasData ||
            therapistFrontSnapshots.data!.docs.isEmpty) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 202, 244, 255), // #CAF4FF40
                  Color.fromARGB(255, 230, 223, 223), // #E6DFDF40
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: const Center(
              child: Scaffold(body: Text("No therapist found.")),
            ),
          );
        }
        if (therapistFrontSnapshots.hasError) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 202, 244, 255), // #CAF4FF40
                  Color.fromARGB(255, 230, 223, 223), // #E6DFDF40
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: const Center(
              child: Scaffold(body: Text("Something went wrong...")),
            ),
          );
        }

        final loadTherapistFronts = therapistFrontSnapshots.data!.docs;

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 202, 244, 255), // #CAF4FF40
                Color.fromARGB(255, 230, 223, 223), // #E6DFDF40
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 202, 244, 255),
                      Color.fromARGB(255, 210, 238, 243),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
              leading: IconButton(
                onPressed: () {
                 Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Home()));
                },
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
              title: const Text('Therapists'),
              centerTitle: true,
            ),
            body: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    child: ElevatedButton(
                      child: Text("suggestion".toLowerCase()),
                      onPressed: () {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromARGB(184, 1, 54, 53), // Button color
                        foregroundColor: const Color.fromARGB(
                            255, 255, 255, 255), // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between the buttons
                  Container(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                      MaterialPageRoute(builder: (context) => myAppointment()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300], // Button color
                        foregroundColor: Colors.black, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text("my appointment".toLowerCase()),
                    ),
                  ),
                ],
              ),
              Container(
                height: 40,
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: loadTherapistFronts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 27.0,
                      crossAxisCount: 1,
                      childAspectRatio: 2.5),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () async {
                       final  parameter = await FirebaseFirestore.instance.collection('therapistFronts').doc(loadTherapistFronts[index].id).collection('availableTimes');
                      final tfID = loadTherapistFronts[index].id;
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChoosedTherapist(key: key, therapistFrontId: tfID ,)));
                    }, 
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 35.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 25,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                loadTherapistFronts[index].data()['profileImage'], // Replace with Firebase image URL
                                width: 125,
                                height: 125,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 22, top: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      loadTherapistFronts[index]
                                              .data()['firstName'] +
                                          " " +
                                          loadTherapistFronts[index]
                                              .data()['lastName'],
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.local_hospital,
                                        color: Colors.teal, size: 16.0),
                                    Text(loadTherapistFronts[index]
                                        .data()['hospital']),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.star,
                                        color: Color.fromARGB(255, 221, 218, 16),
                                        size: 16.0),
                                    Text('5.0'),
                                  ],
                                ),
                                Container(
                                  height: 50,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              //ListView.builder(
              // itemCount: loadTherapistFronts.length,
              // itemBuilder: (ctx, index) =>
              //Text(loadTherapistFronts[index].data()['firstName']),
            ]),
          ),
        );
      },
    );
  }
}
