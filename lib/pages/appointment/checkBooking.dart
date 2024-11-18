import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_support/pages/home/home.dart';
import 'package:mental_health_support/pages/home/splash.dart';

class CheckBooking extends StatelessWidget {
  final String bookingId;
  const CheckBooking({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      // Use `.doc(bookingId).snapshots()` for real-time updates
      stream: FirebaseFirestore.instance
          .collection('booking')
          .doc(bookingId)
          .snapshots(),
      builder: (ctx, bookingSnapshots) {
        if (bookingSnapshots.connectionState == ConnectionState.waiting) {
          return const SplashHome(); // Loading screen
        }

        if (bookingSnapshots.hasError) {
          return Container(
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
            child: const Center(
              child: Scaffold(body: Text("Something went wrong...")),
            ),
          );
        }

        if (!bookingSnapshots.hasData || !bookingSnapshots.data!.exists) {
          return Container(
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
            child: const Center(
              child: Scaffold(body: Text("No booking found.")),
            ),
          );
        }

        // Access the booking document data
        final bookingData =
            bookingSnapshots.data!.data() as Map<String, dynamic>;

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
                                bookingData[
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
                                      bookingData['firstName'] +
                                          " " +
                                          bookingData['lastName'],
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
                                    Text(bookingData['hospital']),
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
                                      bookingData['meetTime'],
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
                                      bookingData['meetDay'],
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
                  Text("Purchase Date: " + bookingData['createDate']),
                  Text(
                    "Therapist Confirmation: " +
                        (bookingData['confirmed'] == true
                            ? "confirmed"
                            : "not confirmed"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text("Cancle booking"),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Before you Cancle"),
                                    content: Text(
                                        'The therapist will refund you if you choose to cancel this booking.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () async =>
                                              //add element meetTime to array Times
                                              await FirebaseFirestore.instance
                                                  .collection('therapistFronts')
                                                  .doc(bookingData[
                                                      'therapistfrontsId'])
                                                  .collection('availableTimes')
                                                  .doc(bookingData['meetDay'])
                                                  .update({
                                                'times': FieldValue.arrayUnion(
                                                    [bookingData['meetTime']])
                                              }).then((_) async {
                                                await FirebaseFirestore.instance
                                                    .collection('booking')
                                                    .doc(bookingId)
                                                    .update(
                                                        {'isCanceled': true});
                                              }).then((value) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home()));
                                              }).catchError((error) {
                                                print(
                                                    "Failed to add meetTime: $error");
                                              }),
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                  color: Color.fromARGB(
                                                      255, 190, 52, 52)),
                                              child: Text(
                                                'Cancle This booking',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                color: Color.fromARGB(
                                                    255, 155, 155, 155),
                                              ),
                                              child: const Text(
                                                "I change my mind",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )))
                                    ],
                                  ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color.fromARGB(184, 230, 4, 4), // Button color
                          foregroundColor: const Color.fromARGB(
                              255, 255, 255, 255), // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: 20,
                          ),
                          ElevatedButton(
                            child: Text('Meet'),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                  184, 101, 158, 157), // Button color
                              foregroundColor: const Color.fromARGB(
                                  255, 255, 255, 255), // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Text("wait for therapist to start")
                        ],
                      ),
                    ],
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
