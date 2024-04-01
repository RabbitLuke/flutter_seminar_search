import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/features/home/ui/view.dart';
import 'package:flutter_seminar_search/profile/user_profile.dart';

class UserFooter extends StatelessWidget {
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WelcomePage()));
            },
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle person icon tap
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()));
            },
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
