import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_support/pages/home/home.dart';
import 'package:mental_health_support/pages/home/splash.dart';

class ConfirmBooking extends StatelessWidget {
  final String therapistFrontId;
  final String day;
  final String time;
  const ConfirmBooking(
      {super.key,
      required this.therapistFrontId,
      required this.day,
      required this.time});

  Future<DocumentSnapshot<Map<String, dynamic>>> getTherapistData() async {
    return await FirebaseFirestore.instance
        .collection('therapistFronts')
        .doc(therapistFrontId)
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
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
                title: const Text('Appoinment'),
                centerTitle: true,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 2.5,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 35.0),
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
                                therapistFrontSnapshot?['profileImage'] ??
                                    "https://i.pinimg.com/736x/3a/67/19/3a67194f5897030237d83289372cf684.jpg", // Replace with Firebase image URL
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
                                      (therapistFrontSnapshot?['firstName'] ??
                                              "not found") +
                                          " " +
                                          (therapistFrontSnapshot?[
                                                  'lastName'] ??
                                              "not found"),
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
                                    Text(therapistFrontSnapshot?['hospital'] ??
                                        "not found"),
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
                                Text("price per session: " +
                                    (therapistFrontSnapshot?['price'] ??
                                        "not found") +
                                    '฿'),
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
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Align everything to the center
                          children: [
                            const SizedBox(
                                height:
                                    20), // Add vertical spacing above the title
                            const Text(
                              "Confirm Your Purchase",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    22.0, // Optional: Make title slightly larger
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                                height: 20), // Space between title and rows
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.access_time_filled_sharp,
                                  color: Color.fromARGB(255, 19, 19, 19),
                                  size: 25.0,
                                ),
                                const SizedBox(
                                    width: 5), // Spacing between icon and text
                                Text(
                                  this.time,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10), // Space between rows
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Color.fromARGB(255, 19, 19, 19),
                                  size: 25.0,
                                ),
                                const SizedBox(
                                    width: 5), // Spacing between icon and text
                                Text(
                                  this.day.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 22,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSBw8AyeyLSId2jAbZ1Mt7_lcGPlD1sUnYdwI0w8fFFjZkWYbOVvRtgJNqimGHmiu800I&usqp=CAU',
                                width: 180,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.download,
                                  color: Color.fromARGB(255, 19, 19, 19),
                                  size: 25.0,
                                ),
                                Container(
                                  width: 40,
                                ),
                                ElevatedButton(
                                  child: Text("confirm"),
                                  onPressed: () async {
                                    final FirebaseAuth auth =
                                        FirebaseAuth.instance;
                                    final User? user = auth.currentUser;
                                    final String? uid = user?.uid;
                                    await FirebaseFirestore.instance
                                        .collection("booking")
                                        .add({
                                          'isLive': false,
                                      'hospital':
                                          therapistFrontSnapshot?['hospital'] ??
                                              "not found",
                                      'lastName':
                                          therapistFrontSnapshot?['lastName'] ??
                                              "not found",
                                      'firstName': therapistFrontSnapshot?[
                                              'firstName'] ??
                                          "not found",
                                      'confirmed': false,
                                      'isCanceled': false,
                                      'meetDay': this.day,
                                      'meetTime': this.time,
                                      'therapistfrontsId': therapistFrontId,
                                      'uid': uid,
                                      'payed':
                                          therapistFrontSnapshot?['price'] ??
                                              "not found",
                                      'createDate': DateTime.now().toString(),
                                      'therapistProfileImage':
                                          therapistFrontSnapshot?[
                                                  'profileImage'] ??
                                              "https://i.pinimg.com/736x/3a/67/19/3a67194f5897030237d83289372cf684.jpg",
                                    });
                                    //delete element in array times that eqaul to this.time
                                   await FirebaseFirestore.instance
                                        .collection('therapistFronts')
                                        .doc(
                                            therapistFrontId) // Replace this with your actual document ID or reference
                                        .collection('availableTimes')
                                        .doc(this.day)
                                        .update({
                                          'times': FieldValue.arrayRemove([
                                            this.time
                                          ]) // Remove `this.time` from the array
                                        })
                                        .then((value) =>
                                            print('Time removed successfully'))
                                        .catchError((error) => print(
                                            'Failed to remove time: $error'));
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text(
                                                  "Thank you for your purchase"),
                                              content: Text(
                                                  'Please wait for therapist confirmation an do not forget to join on the meet date'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home())),
                                                    child: Text('OK'))
                                              ],
                                            ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(
                                        255, 171, 232, 235), // Button color
                                    foregroundColor: Color.fromARGB(
                                        255, 24, 24, 24), // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
