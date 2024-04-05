import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:flutter_seminar_search/features/api_calls/user_provider.dart';
import 'package:flutter_seminar_search/features/home/ui/view.dart';
import 'package:flutter_seminar_search/features/login/login_component.dart';
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
        'Faculty': userProfileProvider.userProfile.selectedFaculty?.id,
        'Profile_pic': base64ProfilePic,
      }),
    );

    if (response.statusCode == 201) {
      print("User profile created successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please log in!'),
          duration: Duration(seconds: 5),
        ),
      );
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginComponent()));
    } else {
      print("Error creating user profile. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final UserProfile userProfile = userProfileProvider.userProfile;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/seminar-search-background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please select your faculty',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: const Color(0xFF3E3A7A),
                      ),
                    ),
                    child: DropdownButton<Faculty>(
                      value: userProfileProvider.userProfile.selectedFaculty,
                      icon: const Icon(Icons.arrow_downward),
                      iconEnabledColor: Colors.red,
                      elevation: 16,
                      style: const TextStyle(color: Color(0xFF3E3A7A)),
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (Faculty? value) {
                        setState(() {
                          userProfileProvider.userProfile.selectedFaculty =
                              value!;
                        });
                      },
                      items: userProfileProvider.userProfile.faculties
                          .map<DropdownMenuItem<Faculty>>((Faculty value) {
                        return DropdownMenuItem<Faculty>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                      dropdownColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  FutureBuilder<File?>(
                    future: Future.value(
                        userProfileProvider.userProfile.profilePic),
                    builder: (context, snapshot) {
                      print('Connection state: ${snapshot.connectionState}');
                      print('Data: ${snapshot.data}');
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
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
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      UserProfileProvider userProfileProvider =
                          Provider.of<UserProfileProvider>(context,
                              listen: false);
                      userProfileProvider
                          .pickImage(userProfileProvider.userProfile);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 255, 255, 255)),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(200, 50)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: const Text('Upload Profile Picture'),
                  ),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () {
                      _createUserProfile();

                      print(
                          'Submitting user profile: ${userProfile.fNameController.text}, ${userProfile.lNameController.text}, ${userProfile.emailController.text}, ${userProfile.passwordController.text}, ${userProfile.selectedFaculty}, ${userProfile.profilePic}');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF3E3A7A)),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(300, 50)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 255, 255, 255)),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(200, 50)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
