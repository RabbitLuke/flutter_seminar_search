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
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Seminar_Search.png',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 5),
            Text(
              'Seminar Search',
              style: TextStyle(
                color: Color(0xFF3E3A7A),
                fontSize: 36,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),

            // Log In Section
            Text(
              'Log In',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E3A7A),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your login logic here
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3E3A7A),
                minimumSize: Size(300, 50),
                maximumSize: Size(300, 50),
              ),
              child: Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 50),

            Text(
              'OR',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E3A7A),
              ),
            ),

            // Continue with Google Section
            ElevatedButton(
              onPressed: () {
                // Add your Google login logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 182, 182, 182),
                minimumSize: Size(300, 50),
                maximumSize: Size(300, 50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google_logo.png',
                    height: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Sign Up Section
            Divider(
              height: 20,
              thickness: 2,
              color: Colors.black,
            ),
            Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HostOrUser()));
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFF23DFFE), width: 2),
                minimumSize: Size(200, 50),
                maximumSize: Size(200, 50),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


