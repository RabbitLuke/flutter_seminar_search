import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:flutter_seminar_search/features/register/page_two.dart';
import 'package:provider/provider.dart';

import '../api_calls/user_provider.dart';

class PageOne extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    String? validateEmail(String? value) {
      final String pattern = '${ApiConstants.pattern}';
      final regex = RegExp(pattern);
      return value!.isNotEmpty && !regex.hasMatch(value)
          ? 'Enter a valid email address'
          : null;
    }

    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: userProfileProvider.userProfile.fNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: userProfileProvider.userProfile.lNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: userProfileProvider.userProfile.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: validateEmail,
              ),
              TextFormField(
                controller: userProfileProvider.userProfile.passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {
                    // Move to the next page if validation succeeds
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PageTwo()));
                  }
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
