import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../pages/home/home.dart';
import '../pages/login/login.dart';

class AuthService {
  Future<void> signup(
      {required String firstName,
      required String lastName,
      required String role,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final String? uid = user?.uid;

      if (role == "patient") {
         await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'firstName': firstName, 'lastName': lastName, 'role': role});
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => const Home()));
      }
      else if(role == "therapist"){
        await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
           'firstName': firstName,
           'lastName': lastName,
           'role': role,
           'profileImage': 'https://i.pinimg.com/736x/18/b5/b5/18b5b599bb873285bd4def283c0d3c09.jpg',
           });
          await FirebaseFirestore.instance
          .collection('therapistFronts')
          .doc(uid)
          .set({
           'hospital': '',
           'price':'',
           'firstName': firstName,
           'lastName': lastName,
           'profileImage': 'https://i.pinimg.com/736x/18/b5/b5/18b5b599bb873285bd4def283c0d3c09.jpg',
           });
           final avaliabletime = await FirebaseFirestore.instance
        .collection('therapistFronts') // Main collection
        .doc(uid) // Specify the document (therapist ID)
        .collection('availableTimes'); // Subcollection
        //.doc('friday').set('available:');
        avaliabletime.doc('monday').set({'available': false,
        'times': []
        });
        avaliabletime.doc('tuesday').set({'available': false,
        'times': []
        });
        avaliabletime.doc('wednesday').set({'available': false,
        'times': []
        });
        avaliabletime.doc('thursday').set({'available': false,
        'times': []
        });
        avaliabletime.doc('friday').set({'available': false,
        'times': []
        });
        avaliabletime.doc('saturday').set({'available': false,
        'times': []
        });
        avaliabletime.doc('sunday').set({'available': false,
        'times': []
        });
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => const Home()));
      }
     
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else {
        message = e.message ?? 'Failed';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {}
  }

  Future<void> signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => const Home()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      } else {
        message = e.message ?? 'Failed';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {}
  }

  Future<void> signout({required BuildContext context}) async {
    // Capture the Navigator instance first
    final navigator = Navigator.of(context);

    // Perform asynchronous operations
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));

    // Use navigator for navigation
    navigator.pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => Login()),
    );
  }
}
