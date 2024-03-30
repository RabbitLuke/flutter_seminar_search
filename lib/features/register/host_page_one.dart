import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:flutter_seminar_search/features/register/host_page_two.dart';
import 'package:flutter_seminar_search/features/register/page_two.dart';
import 'package:provider/provider.dart';

import '../api_calls/host_provider.dart';

class HostPageOne extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final hostProfileProvider = Provider.of<HostProfileProvider>(context);
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
                controller: hostProfileProvider.hostProfile.fNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: hostProfileProvider.hostProfile.lNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: hostProfileProvider.hostProfile.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: validateEmail,
              ),
              TextFormField(
                controller: hostProfileProvider.hostProfile.passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HostPageTwo()));
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
