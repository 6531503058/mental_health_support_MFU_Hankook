import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_support/pages/appointmentTherapist/AppointmentTherapist.dart';
import 'package:mental_health_support/pages/appointmentTherapist/confirmBookingTherapist.dart';
import 'package:mental_health_support/pages/home/home.dart';
import 'package:mental_health_support/pages/home/splash.dart';

class ManageBooking extends StatelessWidget {
  const ManageBooking({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('booking')
          .where('therapistfrontsId', isEqualTo: currentUid) // Filter by UID
          .snapshots(),
      builder: (ctx, bookingSnapshots) {
        if (bookingSnapshots.connectionState == ConnectionState.waiting) {
          return const SplashHome();
        }
        if (!bookingSnapshots.hasData || bookingSnapshots.data!.docs.isEmpty) {
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
            child:  Center(
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
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
              title: const Text('Appoinment'),
              centerTitle: true,
            ),
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      
                        Text("No Booking found."),
                      ],
                    ),
                  ],
                )),
            ),
          );
        }
        if (bookingSnapshots.hasError) {
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
            child: Center(
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
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
              title: const Text('Appoinment'),
              centerTitle: true,
            ),
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Something went wrong..."),
                      ],
                    ),
                  ],
                )),
            ),
          );
        }

        final loadBooking = bookingSnapshots.data!.docs;

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
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
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
                      child: Text("my page detail".toLowerCase()),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  AppointmentTherapist()));
                      },
                      style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.grey[300], // Button color
                        foregroundColor: Colors.black,
                        // Text color
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
                      
                      },
                      style: ElevatedButton.styleFrom(
                         backgroundColor:
                            Color.fromARGB(184, 1, 54, 53), // Button color
                        foregroundColor: const Color.fromARGB(
                            255, 255, 255, 255),
                        // Text color
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
                  itemCount: loadBooking.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 27.0,
                      crossAxisCount: 1,
                      childAspectRatio: 2.5),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmBookingTherapist(
                                    bookingId: loadBooking[index].id,
                                  )));
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
                                loadBooking[index].data()[
                                    'therapistProfileImage'], // Replace with Firebase image URL
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
                                      loadBooking[index].data()['firstName'] +
                                          " " +
                                          loadBooking[index].data()['lastName'],
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
                                    Text(loadBooking[index].data()['hospital']),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.star,
                                        color:
                                            Color.fromARGB(255, 221, 218, 16),
                                        size: 16.0),
                                    Text('5.0'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_filled_sharp,
                                      color: Color.fromARGB(255, 19, 19, 19),
                                      size: 18.0,
                                    ),
                                    const SizedBox(
                                        width:
                                            5), // Spacing between icon and text
                                    Text(
                                      loadBooking[index].data()['meetTime'],
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_rounded,
                                      color: Color.fromARGB(255, 19, 19, 19),
                                      size: 18.0,
                                    ),
                                    const SizedBox(
                                        width:
                                            5), // Spacing between icon and text
                                    Text(
                                      loadBooking[index].data()['meetDay'],
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
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
