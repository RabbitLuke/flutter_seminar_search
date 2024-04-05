import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3E3A7A),
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 24),
      child: Row(
        children: [
          Image.asset(
            'assets/images/Seminar_Search.png',
            width: 80,
            height: 80,
          ),
          const SizedBox(
              width: 30),
          const Text(
            'Seminar Search',
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
