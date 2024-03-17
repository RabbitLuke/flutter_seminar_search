import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Faculty {
  int id;
  String name;

  Faculty({required this.id, required this.name});
}

class Qualifications {
  int id;
  String name;

  Qualifications({required this.id, required this.name});
}

class HostProfile {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? profilePic;
  TextEditingController yearsOfExperience = TextEditingController();

  List<Qualifications> qualifications;
  Qualifications? selectedQualifiction;
  List<Faculty> faculties;
  Faculty? selectedFaculty;

  HostProfile({required this.faculties, required this.qualifications});
}

class HostProfileProvider extends ChangeNotifier {
  HostProfile _hostProfile = HostProfile(faculties: [], qualifications: []);

  HostProfile get hostProfile => _hostProfile;

  void updateHostProfile(HostProfile newProfile) {
    _hostProfile = newProfile;
    notifyListeners();
  }

  void updateSelectedFaculty(Faculty interest) {
    _hostProfile.selectedFaculty = interest;
    notifyListeners();
  }

  Future<void> fetchFaculties() async {
    const String facultyEndpoint = '/faculty/all';
    final String apiUrl = '${ApiConstants.baseUrl}$facultyEndpoint';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> facultyData = json.decode(response.body);
        print(response.body);

        final List<Faculty> fetchedFaculties = facultyData
            .map((faculty) =>
                Faculty(id: faculty['facultyID'], name: faculty['name']))
            .toList();

        for (var faculty in fetchedFaculties) {
          print(faculty.name);
        }
        _hostProfile.selectedFaculty = fetchedFaculties.first;
        _hostProfile.faculties = fetchedFaculties;
        notifyListeners();
      } else {
        print("Error fetching faculties. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching faculties: $error");
    }
  }

  Future<void> fetchQualifications() async {
    const String qualEndpoint = '/qual/all';
    final String apiUrl = '${ApiConstants.baseUrl}$qualEndpoint';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> qualData = json.decode(response.body);
        print(response.body);

        final List<Qualifications> fetchedQualifications = qualData
            .map((qual) =>
                Qualifications(id: qual['QualID'], name: qual['Name']))
            .toList();

        for (var qual in fetchedQualifications) {
          print(qual.name);
        }
        _hostProfile.selectedQualifiction = fetchedQualifications.first;
        _hostProfile.qualifications = fetchedQualifications;
        notifyListeners();
      } else {
        print(
            "Error fetching qualifications. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching qualifications: $error");
    }
  }

  Future<void> pickImage(HostProfile hostProfile) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery); // or ImageSource.camera
    if (image != null) {
      hostProfile.profilePic = File(image.path);
      // Do something with the selected image file, like displaying it in the UI or uploading it
    }
  }
}
