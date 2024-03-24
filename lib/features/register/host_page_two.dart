import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:flutter_seminar_search/features/api_calls/host_provider.dart';
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
            .hostProfile.selectedFaculty?.id, // Use selectedFaculty
        'Qualifications':
            hostProfileProvider.hostProfile.selectedQualifiction?.id,
        'Years_of_Experience': int.parse(hostProfileProvider
            .hostProfile
            .yearsOfExperience
            .text), //PLEASE DOUBLE CHECK THIS!! IT MIGHT NEED TO BE AN INTEGER
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
    final hostProfileProvider = Provider.of<HostProfileProvider>(context);
    final HostProfile hostProfile = hostProfileProvider.hostProfile;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<Faculty>(
              value: hostProfileProvider.hostProfile.selectedFaculty,
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
                  hostProfileProvider.hostProfile.selectedFaculty = value!;
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
            DropdownButton<Qualifications>(
              value: hostProfileProvider.hostProfile.selectedQualifiction,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (Qualifications? value) {
                // This is called when the user selects an item.
                setState(() {
                  hostProfileProvider.hostProfile.selectedQualifiction = value!;
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
              controller: hostProfileProvider.hostProfile.yearsOfExperience,
              decoration: InputDecoration(labelText: 'Years of Experience'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            FutureBuilder<File?>(
              future: Future.value(hostProfileProvider.hostProfile.profilePic),
              builder: (context, snapshot) {
                print('Connection state: ${snapshot.connectionState}');
                print('Data: ${snapshot.data}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show a loading indicator while loading the image
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
                  return Text('No image selected');
                }
              },
            ),
            SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                HostProfileProvider hostProfileProvider =
                    Provider.of<HostProfileProvider>(context, listen: false);
                hostProfileProvider.pickImage(hostProfileProvider.hostProfile);
              },
              child: Text('Upload Profile Picture'),
            ),
            ElevatedButton(
              onPressed: () {
                // Get the final user profile data
                _createHostProfile();

                // TODO: Submit the user profile data to your API
                print(
                    'Submitting user profile: ${hostProfile.fNameController.text}, ${hostProfile.lNameController.text}, ${hostProfile.emailController.text}, ${hostProfile.passwordController.text}, ${hostProfile.selectedFaculty}, ${hostProfile.profilePic}');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
