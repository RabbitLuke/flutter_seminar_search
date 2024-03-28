import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/common/host_footer.dart';

class LogoutPageHost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Handle logout action
          },
          child: Text('Log Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          ),
        ),
      ),
      bottomNavigationBar: HostFooter(), // Include the Footer widget here
    );
  }
}