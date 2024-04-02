import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seminar_search/common/header.dart';
import 'package:flutter_seminar_search/common/user_footer.dart';
import 'package:flutter_seminar_search/features/api_calls/user_provider.dart';
import 'package:flutter_seminar_search/features/authentication/index.dart';
import 'package:flutter_seminar_search/features/login/login_component.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserProfileProvider>(context, listen: false)
          .fetchUserInfo(),
      builder: (context, AsyncSnapshot<UserInfo> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is loading
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurred
          return Text('Error: ${snapshot.error}');
        } else {
          // Data loaded successfully
          final userInfo = snapshot.data!;
          return Material(
            // Wrap YourDisplayWidget with Material
            child: LogoutPageUser(userInfo: userInfo),
          );
        }
      },
    );
  }
}

class LogoutPageUser extends StatelessWidget {
  final UserInfo userInfo;

  const LogoutPageUser({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    // Decode the base64 string for the profile photo
    Uint8List bytes = base64Decode(userInfo.profilePhoto);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/seminar-search-background.png',
                fit: BoxFit.fill, // Change fit to BoxFit.fill
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 150), // Adjust this value to move the content down
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display user information
                      ClipOval(
                        child: Container(
                          width: 200,
                          height:
                              200, // Ensure width and height are equal for a perfect circle
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(bytes),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Display user information
                      Text(
                        '${userInfo.firstName} ${userInfo.lastName}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 28,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${userInfo.emalAddress}',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 28,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),),
                      const SizedBox(
                          height:
                              120), // Add space between user info and button
                      // Logout button
                      ElevatedButton(
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomHeader(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: UserFooter(), // Include the Footer widget here
    );
  }
}
