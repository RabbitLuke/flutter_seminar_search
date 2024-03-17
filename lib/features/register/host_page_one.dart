import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/features/register/host_page_two.dart';
import 'package:flutter_seminar_search/features/register/page_two.dart';
import 'package:provider/provider.dart';

import '../api_calls/host_provider.dart';

class HostPageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hostProfileProvider = Provider.of<HostProfileProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: hostProfileProvider.hostProfile.fNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: hostProfileProvider.hostProfile.lNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: hostProfileProvider.hostProfile.emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: hostProfileProvider.hostProfile.passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () {
                // Move to the next page and update the user profile
                Navigator.push(context, MaterialPageRoute(builder: (context) => HostPageTwo()));
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
