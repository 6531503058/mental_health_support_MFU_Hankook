import 'package:flutter/material.dart';

class MeetRoom extends StatelessWidget {
  const MeetRoom({super.key});

  @override
  Widget build(BuildContext context) {
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
              title: const Text('Meet Room'),
              centerTitle: true,
            ),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Connecting...  ',
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
