import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:flutter_seminar_search/features/api_calls/user_provider.dart';
import 'package:flutter_seminar_search/imageConverter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  TextEditingController interestsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProfileProvider>(context, listen: false).fetchFaculties();
  }

  Future<void> _createUserProfile() async {
    final userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);

    String? base64ProfilePic =
        await imageToBase64(userProfileProvider.userProfile.profilePic);

    const String createUserEndpoint = '/user/create';
    final String apiUrl = '${ApiConstants.baseUrl}$createUserEndpoint';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'First_Name': userProfileProvider.userProfile.fNameController.text,
        'Last_Name': userProfileProvider.userProfile.lNameController.text,
        'Email': userProfileProvider.userProfile.emailController.text,
        'Password': userProfileProvider.userProfile.passwordController.text,
        'Faculty': userProfileProvider
            .userProfile.selectedFaculty?.id, // Use selectedFaculty
        'Profile_pic': base64ProfilePic, // Assuming profilePic is a string
      }),
    );

    if (response.statusCode == 200) {
      // User profile created successfully
      print("User profile created successfully");
    } else {
      // Error in creating user profile
      print("Error creating user profile. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final UserProfile userProfile = userProfileProvider.userProfile;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<Faculty>(
              value: userProfileProvider.userProfile.selectedFaculty,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (Faculty? value) {
                // This is called when the user selects an item.
                setState(() {
                  userProfileProvider.userProfile.selectedFaculty = value!;
                });
              },
              items: userProfileProvider.userProfile.faculties
                  .map<DropdownMenuItem<Faculty>>((Faculty value) {
                return DropdownMenuItem<Faculty>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
            FutureBuilder<File?>(
              future: Future.value(userProfileProvider.userProfile.profilePic),
              builder: (context, snapshot) {
                print('Connection state: ${snapshot.connectionState}');
                print('Data: ${snapshot.data}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator while loading the image
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  File? imageFile = snapshot.data;
                  return imageFile != null
                      ? Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container();
                } else {
                  return const Text('No image selected');
                }
              },
            ),
            const SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                UserProfileProvider userProfileProvider =
                    Provider.of<UserProfileProvider>(context, listen: false);
                userProfileProvider.pickImage(userProfileProvider.userProfile);
              },
              child: const Text('Upload Profile Picture'),
            ),
            ElevatedButton(
              onPressed: () {
                _createUserProfile();

                print(
                    'Submitting user profile: ${userProfile.fNameController.text}, ${userProfile.lNameController.text}, ${userProfile.emailController.text}, ${userProfile.passwordController.text}, ${userProfile.selectedFaculty}, ${userProfile.profilePic}');
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
