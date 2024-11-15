import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_support/services/auth_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<Map<String, String>?> getUserDetails() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      // Assuming the 'firstName' and 'role' fields exist in the document
      final firstName = userDoc['firstName'];
      final role =
          userDoc['role'] ?? 'No Role'; // Default to 'No Role' if not found
      return {'firstName': firstName, 'role': role};
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
          title: const Center(child: Text("Menu")),
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // CircleAvatar for profile picture
                CircleAvatar(
                  radius: 95, // Adjust the size of the circle
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIRUMhOrPk4hJXZmN6UuDwutU_lW89PGqv7BHa5kkDUXKCPk1HeSGO5iHOt7KR9ly0bIs&usqp=CAU'), // For internet image
                  // Or use an asset image instead:
                  // backgroundImage: AssetImage(profilePictureAsset), // For asset image
                ),
                const SizedBox(
                  height: 25,
                ),
                FutureBuilder<Map<String, String>?>(
                  future: getUserDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return const Text("User details not found");
                    }
                    // Display user's name and role
                    final firstName = snapshot.data?['firstName'] ?? 'Unknown';
                    final role = snapshot.data?['role'] ?? 'Unknown role';
                    return Text("Hello👋, $firstName ($role)");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.email!.toString(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMenuItem(Icons.article, "Feeds", context),
                        _buildMenuItem(
                            Icons.calendar_today, "Appointment", context),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMenuItem(Icons.person, "Profile", context),
                        _buildMenuItem(Icons.groups, "Club", context),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMenuItem(Icons.chat, "Chats", context),
                        _buildMenuItem(Icons.live_tv, "Lives", context),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: Container(),
                ),

                _logout(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 15, top: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(103, 255, 255, 255), // Set the background color
          borderRadius: BorderRadius.circular(
              12), // Adjust this value for more or less rounding
        ),
        width: 165,
        height: 75,
        child: InkWell(
          onTap: () {
            // Handle the tap action, navigate to the respective page
            print('Tapped on $title');
            // Example: Navigator.pushNamed(context, '/${title.toLowerCase()}');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Align children to the top (start) of the Column
            crossAxisAlignment: CrossAxisAlignment.start, //
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  icon,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(title,
                    style: TextStyle(
                      fontSize: 18,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Color.fromARGB(255, 31, 31, 31),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        side: const BorderSide(
          color: Color.fromARGB(133, 90, 203, 255), // Outline color
          width: 2.0, // Outline width
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 40),
        elevation: 0,
      ),
      onPressed: () async {
        await AuthService().signout(context: context);
      },
      child: const Text("Sign Out"),
    );
  }
}
