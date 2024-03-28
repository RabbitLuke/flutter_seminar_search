import 'package:flutter/material.dart';

class HostFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3E3A7A),
      height: 50, // Adjust the height according to your design
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.book),
            onPressed: () {
              // Handle book icon tap
            },
            color: Colors.white,
          ),

          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Handle book icon tap
            },
            color: Colors.white,
          ),

          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Handle person icon tap
            },
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

