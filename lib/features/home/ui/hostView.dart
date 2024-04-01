// import necessary packages
import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/common/host_footer.dart';

// WelcomePage widget
class WelcomePageHost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Wrap the Stack with a Scaffold
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Welcome Host!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: HostFooter(), // Use the Footer widget here
          ),
        ],
      ),
    );
  }
}
