import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mental_health_support/pages/home/home.dart';
import 'package:mental_health_support/pages/home/splash.dart';
import 'package:mental_health_support/pages/login/login.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      scaffoldBackgroundColor: Colors.transparent, // Set to transparent to show gradient
    ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return const SplashHome();
          }
          if (snapshot.hasData) {
            return const Home();
          }
          return Login();
        },
      ),
    );
  }
}
