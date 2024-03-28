import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3E3A7A), // Set the background color to purple
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 24),
      child: Row(
        children: [
          // Add your logo here
          Image.asset('assets/images/Seminar_Search.png',width: 80,
              height: 80,), // Adjust the path based on your project structure
          SizedBox(width: 30), // Add some space between logo and other content
          Text(
            'Seminar Search', // Replace with your app name
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
