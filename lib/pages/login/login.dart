import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:mental_health_support/pages/signup/signup.dart';
import 'package:mental_health_support/pages/signup/signupAsTherapist.dart';
import 'package:mental_health_support/services/auth_service.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _signup(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Hello Again',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 80),
              _emailAddress(),
              const SizedBox(height: 20),
              _password(),
              const SizedBox(height: 50),
              _signin(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email Address'),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'example@gmail.com',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _password() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password'),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          controller: _passwordController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'password',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _signin(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
      ),
      onPressed: () async {
        try {
          await AuthService().signin(
            email: _emailController.text,
            password: _passwordController.text,
            context: context,
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      },
      child: const Text('Sign In',style: TextStyle(color: Colors.white),),
    );
  }

  Widget _signup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'New User? ',
              style: TextStyle(
                color: Color(0xff6A6A6A),
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: 'Create Account as Patient',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 191, 255),
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
            ),
            const TextSpan(
              text: ' or ',
              style: TextStyle(
                color: Color(0xff6A6A6A),
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: 'Create Account as Therapist',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 191, 255),
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupTherapist()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
