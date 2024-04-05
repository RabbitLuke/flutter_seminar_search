import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seminar_search/common/host_footer.dart';
import 'package:flutter_seminar_search/features/authentication/ui/bloc.dart';
import 'package:flutter_seminar_search/features/login/login_component.dart';

class HostProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authBloc.authService.logout();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginComponent()));
          },
          child: const Text('Log Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          ),
        ),
      ),
      bottomNavigationBar: HostFooter(),
    );
  }
}
