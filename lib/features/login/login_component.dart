import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seminar_search/features/authentication/index.dart';
import 'package:flutter_seminar_search/features/authentication/ui/bloc.dart';
import 'package:flutter_seminar_search/features/register/host_or_user.dart';
import 'package:flutter_seminar_search/features/register/page_one.dart';

class LoginComponent extends StatelessWidget {
  const LoginComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/seminar-search-background.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Seminar_Search.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Seminar Search',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 36,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    // Add your login logic here
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E3A7A),
                    minimumSize: const Size(300, 50),
                    maximumSize: const Size(300, 50),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                const Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),

                // Continue with Google Section
                ElevatedButton(
                  onPressed: () {
                    // Add your Google login logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 182, 182, 182),
                    minimumSize: const Size(300, 50),
                    maximumSize: const Size(300, 50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google_logo.png',
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Sign Up Section
                const Divider(
                  height: 20,
                  thickness: 2,
                  color: Color(0xFF23DFFE),
                ),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const HostOrUser()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor: Colors.black, // Text color
                    side: const BorderSide(
                        color: Color(0xFF23DFFE),
                        width: 2), // Border color and width
                    minimumSize: const Size(200, 50),
                    maximumSize: const Size(200, 50),
                  ),
                  child: const Text(
                    'Sign Up',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
