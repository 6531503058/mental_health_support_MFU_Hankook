import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_support/pages/appointment/meetRoom.dart';
import 'package:mental_health_support/pages/home/splash.dart';

class ConfirmBookingTherapist extends StatelessWidget {
  final String bookingId;
  const ConfirmBookingTherapist({super.key, required this.bookingId});

  Future<void> updateField(String field, bool value) async {
    await FirebaseFirestore.instance.collection('booking').doc(bookingId).update({field: value});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('booking')
          .doc(bookingId)
          .snapshots(),
      builder: (ctx, bookingSnapshots) {
        if (bookingSnapshots.connectionState == ConnectionState.waiting) {
          return const SplashHome(); // Loading screen
        }

        if (bookingSnapshots.hasError) {
          return const Center(
            child: Text("Something went wrong..."),
          );
        }

        if (!bookingSnapshots.hasData || !bookingSnapshots.data!.exists) {
          return const Center(
            child: Text("No booking found."),
          );
        }

        final bookingData = bookingSnapshots.data!.data() as Map<String, dynamic>;
        final String? patientUid = bookingData['uid']; // Fetch the UID for the patient

        return Scaffold(
          appBar: AppBar(
            title: const Text("Booking Details"),
            centerTitle: true,
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
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 202, 244, 255),
                  Color.fromARGB(255, 230, 223, 223),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Fetch and display the patient's name
                 
                  // Booking Details
                  const SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 2.5,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 35.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                bookingData['therapistProfileImage'],
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
                                Text(
                                  "${bookingData['firstName']} ${bookingData['lastName']}",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.local_hospital,
                                        color: Colors.teal, size: 16.0),
                                    Text(bookingData['hospital']),
                                  ],
                                ),
                                const Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Color.fromARGB(255, 221, 218, 16),
                                        size: 16.0),
                                    Text('5.0'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_filled_sharp,
                                        size: 18.0),
                                    const SizedBox(width: 5),
                                    Text(bookingData['meetTime']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month_rounded,
                                        size: 18.0),
                                    const SizedBox(width: 5),
                                    Text(bookingData['meetDay']),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                    const SizedBox(height: 20),
                   if (patientUid != null)
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(patientUid)
                          .snapshots(),
                      builder: (ctx, userSnapshots) {
                        if (userSnapshots.connectionState == ConnectionState.waiting) {
    
                        }

                        if (userSnapshots.hasError || !userSnapshots.hasData || !userSnapshots.data!.exists) {
                          return const Text("Patient name not available.");
                        }

                        final userData = userSnapshots.data!.data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Text(
                            "Patient name: ${userData['firstName']} ${userData['lastName']}",
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        );
                      },
                    ),
                  Text("Purchase Date: ${bookingData['createDate']}",
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),),
                  Text(
                    "Therapist Confirmation: ${bookingData['confirmed'] == true ? "confirmed" : "not confirmed"}",
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                  ),
                  Text(
                    "Therapist Confirmation: ${bookingData['isCanceled'] == true ? "cancled" : "not cancled"}",
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: Column(
                    children:[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Cancel Booking'),
                        Switch(
                          value: bookingData['isCanceled'] ?? false,
                          onChanged: (newValue) async {
                            await updateField('isCanceled', newValue);
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Confirm Booking'),
                        Switch(
                          value: bookingData['confirmed'] ?? false,
                          onChanged: (newValue) async {
                            await updateField('confirmed', newValue);
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Start Session'),
                        Switch(
                          value: bookingData['isLive'] ?? false,
                          onChanged: (newValue) async {
                            await updateField('isLive', newValue);
                            if (newValue) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MeetRoom(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    ]
                                     ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
