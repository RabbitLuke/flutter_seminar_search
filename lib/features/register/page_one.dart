import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/features/register/page_two.dart';
import 'package:provider/provider.dart';

import '../api_calls/user_provider.dart';

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: userProfileProvider.userProfile.fNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: userProfileProvider.userProfile.lNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: userProfileProvider.userProfile.emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: userProfileProvider.userProfile.passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () {
                // Move to the next page and update the user profile
                Navigator.push(context, MaterialPageRoute(builder: (context) => PageTwo()));
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
