import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:flutter_seminar_search/features/api_calls/user_provider.dart';
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
        'Faculty': userProfileProvider.userProfile.selectedFaculty?.id, // Use selectedFaculty
        'Profile_pic': userProfileProvider.userProfile.profilePic.text, // Assuming profilePic is a string
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
    const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

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
              items: userProfileProvider.userProfile.faculties.map<DropdownMenuItem<Faculty>>((Faculty value) {
                return DropdownMenuItem<Faculty>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),

            TextFormField(
              controller: userProfileProvider.userProfile.profilePic,
              decoration: InputDecoration(labelText: 'Profile Picture'),
            ),
            ElevatedButton(
              onPressed: () {
                // Get the final user profile data
                _createUserProfile();

                // TODO: Submit the user profile data to your API
                print(
                    'Submitting user profile: ${userProfile.fNameController.text}, ${userProfile.lNameController.text}, ${userProfile.emailController.text}, ${userProfile.passwordController.text}, ${userProfile.selectedFaculty}');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
