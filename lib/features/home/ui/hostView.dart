// import necessary packages
import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/features/add_seminar/page_one.dart';

// WelcomePage widget
class WelcomePageHost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to the desired page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SeminarPageOne()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome Host!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
