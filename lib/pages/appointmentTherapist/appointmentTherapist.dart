import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_support/pages/appointment/confirmBooking.dart';
import 'package:mental_health_support/pages/appointmentTherapist/editTherapistFront.dart';
import 'package:mental_health_support/pages/appointmentTherapist/manageBooking.dart';
import 'package:mental_health_support/pages/home/home.dart';
import 'package:mental_health_support/pages/home/splash.dart';
class AppointmentTherapist extends StatelessWidget {


  const AppointmentTherapist({super.key});
  
Future<DocumentSnapshot<Map<String, dynamic>>> getTherapistData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return 
    await FirebaseFirestore.instance
        .collection('therapistFronts')
        .doc(userId)
        .get();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: getTherapistData(),
      builder: (context, therapistSnapshot) {
        if (therapistSnapshot.connectionState == ConnectionState.waiting) {
          
         return const SplashHome();
        }

        if (therapistSnapshot.hasError) {
          return const Center(child: Text("Failed to fetch therapist data."));
        }

        if (!therapistSnapshot.hasData || !therapistSnapshot.data!.exists) {
          return const Center(child: Text("Therapist not found."));
        }

        final therapistFrontSnapshot = therapistSnapshot.data!.data();
        final userId = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder(
      
        stream: FirebaseFirestore.instance
            .collection('therapistFronts')
            .doc(userId)
            .collection('availableTimes')
            .snapshots(),
        builder: (ctx, availableSnapshots) {
          if (availableSnapshots.connectionState == ConnectionState.waiting) {
             return const SplashHome();
          }
          if (!availableSnapshots.hasData ||
              availableSnapshots.data!.docs.isEmpty) {
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
          if (availableSnapshots.hasError) {
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
              child: Container(
                child: const Center(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Text("Something went wrong...")),
                ),
              ),
            );
          }

          final loadAvailable = availableSnapshots.data!.docs;
          final orderedDays = [
            "monday",
            "tuesday",
            "wednesday",
            "thursday",
            "friday",
            "saturday",
            "sunday"
          ];
          loadAvailable.sort((a, b) {
            int indexA = orderedDays.indexOf(a.id.toLowerCase());
            int indexB = orderedDays.indexOf(b.id.toLowerCase());
            return indexA.compareTo(indexB);
          });

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
              title: const Text('Appoinment'),
              centerTitle: true,
            ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    child: ElevatedButton(
                      child: Text("My Page Detail".toLowerCase()),
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
                      MaterialPageRoute(builder: (context) => ManageBooking()));
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
                  AspectRatio(
                    aspectRatio: 2.5,
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
                                  therapistFrontSnapshot?['profileImage'] ?? "https://i.pinimg.com/736x/3a/67/19/3a67194f5897030237d83289372cf684.jpg", // Replace with Firebase image URL
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
                                        (therapistFrontSnapshot?['firstName'] ?? "not found") +
                                            " " +
                                           ( therapistFrontSnapshot?['lastName'] ?? "not found"),
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
                                      Text(therapistFrontSnapshot?['hospital']??"not found"),
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
                                  Text("price per session: "+(therapistFrontSnapshot?['price']??"not found")+'฿'),
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
                  Container(height: 30,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: loadAvailable.length,
                      itemBuilder: (ctx, index) {
                        // Get the times field and check if it's a list
                        final times = loadAvailable[index].data()['times'];
                        final day = loadAvailable[index].id;
                        
                        if (times is! List<dynamic> ||
                            loadAvailable[index].data()['available'] == false) {
                          // Handle the case where 'times' is null or not a list
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("No available times on: ${day.toUpperCase()}"),
                              Container(height: 20,)
                            ],
                          );
                        }
                    
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Available Times on: ${day}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              spacing: 8.0, // Space between buttons
                              children: times.map<Widget>((time) {
                                return ElevatedButton(
                                  onPressed: () {
                                     
                                  },
                                  child:
                                      Text(time.toString()), // Display time on the button
                                );
                              }).toList(), // Convert the mapped list to a list of Widgets
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                   Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(height: 20,),
                          ElevatedButton(
                            onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditTherapistFront()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: 
                                   Color.fromARGB(255, 22, 179, 176), // Conditional color
                              foregroundColor:
                                  Colors.white, // Common text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Edit'),
                          ),
                         
                        ],
                      ),
                      Container(height: 40,)
                ],
              ),
            ),
          );
        });
  });
}
}

