import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_support/pages/appointmentTherapist/AppointmentTherapist.dart';

class EditTherapistFront extends StatefulWidget {
  const EditTherapistFront({super.key});

  @override
  _EditTherapistFrontState createState() => _EditTherapistFrontState();
}

class _EditTherapistFrontState extends State<EditTherapistFront> {
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _profileImageController = TextEditingController();
  final Map<String, TextEditingController> _timeControllers = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final docSnapshot = await FirebaseFirestore.instance
        .collection('therapistFronts')
        .doc(userId)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      _hospitalController.text = data?['hospital'] ?? '';
      _priceController.text = data?['price']?.toString() ?? '';
      _profileImageController.text = data?['profileImage'] ?? '';
    }
  }

  Future<void> _updateTherapistData(String field, String value) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('therapistFronts')
        .doc(userId)
        .update({field: value});
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

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
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  AppointmentTherapist()));
            },
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          title: const Text('Edit Therapist Details'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Editable Hospital Field
                TextField(
                  controller: _hospitalController,
                  decoration: InputDecoration(
                    labelText: 'Hospital',
                    filled: true,
                    fillColor: const Color(0xffF7F7F9),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_hospitalController.text.isNotEmpty) {
                      _updateTherapistData('hospital', _hospitalController.text);
                    }
                  },
                  child: const Text('Update Hospital'),
                ),
                const SizedBox(height: 16),

                // Editable Price Field
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price (Baht ฿)',
                    filled: true,
                    fillColor: const Color(0xffF7F7F9),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_priceController.text.isNotEmpty) {
                      _updateTherapistData('price', _priceController.text);
                    }
                  },
                  child: const Text('Update Price'),
                ),
                const SizedBox(height: 16),

                // Editable Profile Image Field
                TextField(
                  controller: _profileImageController,
                  decoration: InputDecoration(
                    labelText: 'Profile Image URL',
                    filled: true,
                    fillColor: const Color(0xffF7F7F9),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_profileImageController.text.isNotEmpty) {
                      _updateTherapistData(
                          'profileImage', _profileImageController.text);
                    }
                  },
                  child: const Text('Update Profile Image'),
                ),
                const SizedBox(height: 24),

                // Available Times List
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('therapistFronts')
                      .doc(userId)
                      .collection('availableTimes')
                      .snapshots(),
                  builder: (ctx, availableSnapshots) {
                    if (availableSnapshots.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!availableSnapshots.hasData ||
                        availableSnapshots.data!.docs.isEmpty) {
                      return const Center(child: Text("No available times found."));
                    }
                    if (availableSnapshots.hasError) {
                      return const Center(child: Text("Something went wrong."));
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
                      int indexA =
                          orderedDays.indexOf(a.id.toLowerCase());
                      int indexB =
                          orderedDays.indexOf(b.id.toLowerCase());
                      return indexA.compareTo(indexB);
                    });

                     return Expanded(
                      child: ListView.builder(
                        itemCount: loadAvailable.length,
                        itemBuilder: (ctx, index) {
                          final dayDoc = loadAvailable[index];
                          final day = dayDoc.id;
                          final data = dayDoc.data();
                          final times = data['times'] as List<dynamic>? ?? [];
                          final available = data['available'] as bool? ?? false;


                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Available Times on: ${day.toUpperCase()}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Switch(
                                    value: available,
                                    onChanged: (newValue) async {
                                      await FirebaseFirestore.instance
                                          .collection('therapistFronts')
                                          .doc(userId)
                                          .collection('availableTimes')
                                          .doc(day)
                                          .update({'available': newValue});
                                    },
                                  ),
                                ],
                              ),
                              Wrap(
                                spacing: 8.0,
                                children: times.map<Widget>((time) {
                                  return Chip(
                                    label: Text(time.toString()),
                                    deleteIcon: const Icon(Icons.close),
                                    onDeleted: () async {
                                      // Delete the time from Firestore
                                      await FirebaseFirestore.instance
                                          .collection('therapistFronts')
                                          .doc(userId)
                                          .collection('availableTimes')
                                          .doc(day)
                                          .update({
                                        'times': FieldValue.arrayRemove([time]),
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              // New Time Input Field
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _timeControllers.putIfAbsent(
                                        day,
                                        () => TextEditingController(),
                                      ), // Ensure a controller is assigned for each day
                                      decoration: InputDecoration(
                                        labelText: "Add new time",
                                        filled: true,
                                        fillColor: const Color(0xffF7F7F9),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final newTime =
                                          _timeControllers[day]?.text;
                                      if (newTime != null &&
                                          newTime.isNotEmpty) {
                                        await FirebaseFirestore.instance
                                            .collection('therapistFronts')
                                            .doc(userId)
                                            .collection('availableTimes')
                                            .doc(day)
                                            .update({
                                          'times':
                                              FieldValue.arrayUnion([newTime]),
                                        });
                                        _timeControllers[day]
                                            ?.clear(); // Clear the input field
                                      }
                                    },
                                    child: const Text("Add"),
                                  ),
                                ],
                              ),
                              const Divider(height: 20),
                            ],
                          );
                        },
                      ),
                    );

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
