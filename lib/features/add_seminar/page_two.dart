import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:flutter_seminar_search/features/api_calls/seminar_provider.dart';
import 'package:flutter_seminar_search/features/home/ui/hostView.dart';
import 'package:flutter_seminar_search/imageConverter.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:http/http.dart' as http;

class SeminarPageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<SeminarPageTwo> {
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _timeFormat = DateFormat('HH:mm:ss');
  final RegExp _timeRegex = RegExp(
    r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$',
  );

  @override
  void initState() {
    super.initState();
    Provider.of<SeminarProvider>(context, listen: false).fetchFaculties();
  }

  Future<void> _createSeminar() async {
    final seminarProvider =
        Provider.of<SeminarProvider>(context, listen: false);

    String? base64ProfilePic =
        await imageToBase64(seminarProvider.seminarProfile.cover_photo);

    const String createSeminarEndpoint = '/seminar/create';
    final String apiUrl = '${ApiConstants.baseUrl}$createSeminarEndpoint';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Title': seminarProvider.seminarProfile.seminarTitle.text,
        'no_of_seats': int.parse(seminarProvider.seminarProfile.seminarNo_of_seats.text),
        'Location': seminarProvider.seminarProfile.seminarLocation.text,
        'Time': seminarProvider.seminarProfile.seminarTime.text,
        'Date': seminarProvider.seminarProfile.seminarDate.text,
        'Duration': int.parse(seminarProvider.seminarProfile.seminarDuration.text),
        'facultyID': seminarProvider.seminarProfile.selectedFaculty?.id, // Use selectedFaculty
        'cover_photo': base64ProfilePic, // Assuming profilePic is a string
      }),
    );

    if (response.statusCode == 201) {
      // User profile created successfully
      print("Seminar created successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seminar created successfully'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    } else {
      // Error in creating user profile
      print("Error creating seminar Status code: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error creating seminar. Please try again.'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    }
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Time cannot be empty';
    }
    if (!_timeRegex.hasMatch(value)) {
      return 'Invalid time format. Please use HH:mm:ss';
    }
    return null; // Return null if validation succeeds
  }

  @override
  Widget build(BuildContext context) {
    final seminarProvider = Provider.of<SeminarProvider>(context);
    final SeminarProfile seminarProfile = seminarProvider.seminarProfile;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<Faculty>(
              value: seminarProvider.seminarProfile.selectedFaculty,
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
                  seminarProvider.seminarProfile.selectedFaculty = value!;
                });
              },
              items: seminarProvider.seminarProfile.faculties
                  .map<DropdownMenuItem<Faculty>>((Faculty value) {
                return DropdownMenuItem<Faculty>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
            const Text(
              'Select Seminar Date:',
              style: TextStyle(fontSize: 16.0),
            ),
            DateTimeField(
              controller: seminarProvider.seminarProfile.seminarDate,
              format: _dateFormat,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: currentValue ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                return date;
              },
              decoration: const InputDecoration(
                hintText: 'YYYY-MM-DD',
                border: OutlineInputBorder(),
              ),
            ),
            const Text(
              'Choose a start Time:',
              style: TextStyle(fontSize: 16.0),
            ),
            TextFormField(
              controller: seminarProvider.seminarProfile.seminarTime,
              decoration: const InputDecoration(
                hintText: 'HH:mm:ss',
                border: OutlineInputBorder(),
              ),
              validator: _validateTime,
            ),
            FutureBuilder<File?>(
              future: Future.value(seminarProvider.seminarProfile.cover_photo),
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
                SeminarProvider seminarProvider =
                    Provider.of<SeminarProvider>(context, listen: false);
                seminarProvider.pickImage(seminarProvider.seminarProfile);
              },
              child: const Text('Upload Profile Picture'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_validateTime(
                        seminarProvider.seminarProfile.seminarTime.text) ==
                    null) {
                  // Time input is valid, proceed with saving seminar
                  String selectedTime =
                      seminarProvider.seminarProfile.seminarTime.text;
                  // Continue with saving the seminar...
                } else {
                  // Time input is invalid, show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid time')),
                  );
                }
                _createSeminar();
                print(
                    'Submitting user profile: ${seminarProfile.seminarTitle.text}, ${seminarProfile.seminarNo_of_seats.text}, ${seminarProfile.seminarLocation.text}, ${seminarProfile.seminarTime.text}, ${seminarProfile.seminarDate.text}, ${seminarProfile.seminarDuration.text}');
              },
              child: const Text('Save Seminar'),
            ),
            ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomePageHost()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
                      minimumSize: const Size(200, 50),
                      maximumSize: const Size(200, 50),
                    ),
                    child: const Text(
                      'Return Home',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
