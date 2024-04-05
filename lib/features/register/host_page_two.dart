import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:flutter_seminar_search/features/api_calls/host_provider.dart';
import 'package:flutter_seminar_search/features/login/login_component.dart';
import 'package:flutter_seminar_search/imageConverter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HostPageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<HostPageTwo> {
  @override
  void initState() {
    super.initState();
    Provider.of<HostProfileProvider>(context, listen: false).fetchFaculties();
    Provider.of<HostProfileProvider>(context, listen: false)
        .fetchQualifications();
  }

  Future<void> _createHostProfile() async {
    final hostProfileProvider =
        Provider.of<HostProfileProvider>(context, listen: false);

    String? base64ProfilePic =
        await imageToBase64(hostProfileProvider.hostProfile.profilePic);

    const String createHostEndpoint = '/host/create';
    final String apiUrl = '${ApiConstants.baseUrl}$createHostEndpoint';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'First_Name': hostProfileProvider.hostProfile.fNameController.text,
        'Last_Name': hostProfileProvider.hostProfile.lNameController.text,
        'Email': hostProfileProvider.hostProfile.emailController.text,
        'Password': hostProfileProvider.hostProfile.passwordController.text,
        'Faculty': hostProfileProvider
            .hostProfile.selectedFaculty?.id,
        'Qualifications':
            hostProfileProvider.hostProfile.selectedQualifiction?.id,
        'Years_of_Experience': int.parse(hostProfileProvider
            .hostProfile
            .yearsOfExperience
            .text),
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
    final hostProfileProvider = Provider.of<HostProfileProvider>(context);
    final HostProfile hostProfile = hostProfileProvider.hostProfile;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/seminar-search-background.png',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor:
              Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
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
                  DropdownButton<Faculty>(
                    value: hostProfileProvider.hostProfile.selectedFaculty,
                    icon: const Icon(Icons.arrow_downward),
                    iconEnabledColor: Colors.red,
                    elevation: 16,
                    style: const TextStyle(color: Color(0xFF3E3A7A)),
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (Faculty? value) {
                      setState(() {
                        hostProfileProvider.hostProfile.selectedFaculty =
                            value!;
                      });
                    },
                    items: hostProfileProvider.hostProfile.faculties
                        .map<DropdownMenuItem<Faculty>>((Faculty value) {
                      return DropdownMenuItem<Faculty>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please select your highest qualification',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  DropdownButton<Qualifications>(
                    icon: const Icon(Icons.arrow_downward),
                    iconEnabledColor: Colors.red,
                    elevation: 16,
                    style: const TextStyle(color: Color(0xFF3E3A7A)),
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (Qualifications? value) {
                      setState(() {
                        hostProfileProvider.hostProfile.selectedQualifiction =
                            value!;
                      });
                    },
                    items: hostProfileProvider.hostProfile.qualifications
                        .map<DropdownMenuItem<Qualifications>>(
                            (Qualifications value) {
                      return DropdownMenuItem<Qualifications>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    controller:
                        hostProfileProvider.hostProfile.yearsOfExperience,
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      hintText: 'Years of Experience',
                      hintStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  FutureBuilder<File?>(
                    future: Future.value(
                        hostProfileProvider.hostProfile.profilePic),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      HostProfileProvider hostProfileProvider =
                          Provider.of<HostProfileProvider>(context,
                              listen: false);
                      hostProfileProvider
                          .pickImage(hostProfileProvider.hostProfile);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 255, 255)),
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
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      _createHostProfile();
                      print(
                          'Submitting user profile: ${hostProfile.fNameController.text}, ${hostProfile.lNameController.text}, ${hostProfile.emailController.text}, ${hostProfile.passwordController.text}, ${hostProfile.selectedFaculty}, ${hostProfile.profilePic}');
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
                          Color.fromARGB(255, 255, 255, 255)),
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
        ),
      ],
    );
  }
}
