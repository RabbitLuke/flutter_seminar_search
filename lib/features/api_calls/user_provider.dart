import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/common/http_helper.dart';
import 'package:flutter_seminar_search/features/api_calls/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_seminar_search/constants.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Faculty {
  int id;
  String name;

  Faculty({required this.id, required this.name});
}

class UserInfo {
  String firstName;
  String lastName;
  String emalAddress;
  String profilePhoto;

  UserInfo(
      {required this.firstName,
      required this.lastName,
      required this.emalAddress,
      required this.profilePhoto});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
        firstName: json['First_Name'],
        lastName: json['Last_Name'],
        emalAddress: json['Email'],
        profilePhoto: json['Profile_pic']);
  }
}

class UserProfile {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? profilePic;
  List<Faculty> faculties;
  Faculty? selectedFaculty;

  UserProfile({required this.faculties});
}

class UserProfileProvider extends ChangeNotifier {
  UserProfile _userProfile = UserProfile(faculties: []);

  UserProfile get userProfile => _userProfile;

  void updateUserProfile(UserProfile newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }

  void updateSelectedFaculty(Faculty interest) {
    _userProfile.selectedFaculty = interest;
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
        _userProfile.selectedFaculty = fetchedFaculties.first;
        _userProfile.faculties = fetchedFaculties;
        notifyListeners();
      } else {
        print("Error fetching faculties. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching faculties: $error");
    }
  }

  Future<void> pickImage(UserProfile userProfile) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery); // or ImageSource.camera
    if (image != null) {
      userProfile.profilePic = File(image.path);
      // Do something with the selected image file, like displaying it in the UI or uploading it
    }
  }

  Future<UserInfo> fetchUserInfo() async {
  try {
    final response = await dio.get('/user/getuser');
    if (response.statusCode == 200) {
      return UserInfo.fromJson(response.data);
    } else {
      log("Error fetching user info. Status code: ${response.statusCode}");
      throw Exception('Failed to fetch user info');
    }
  } catch (error) {
    log("Error fetching user info: $error");
    throw Exception('Failed to fetch user info');
  }
}
}
