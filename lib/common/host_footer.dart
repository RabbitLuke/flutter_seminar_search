import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/features/add_seminar/page_one.dart';
import 'package:flutter_seminar_search/features/api_calls/host_provider.dart';

class HostFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3E3A7A),
      height: 50, // Adjust the height according to your design
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              // Handle book icon tap
            },
            color: Colors.white,
          ),

          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SeminarPageOne()));
            },
            color: Colors.white,
          ),

          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => HostProfile()));
            },
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

