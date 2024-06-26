import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/common/http_helper.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_seminar_search/features/api_calls/dashboard_provider.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class Seminars {
  int id;
  String Title;
  int Duration;
  String Date;
  String Time;
  String Location;
  int no_of_seats;
  String cover_photo;

  Seminars(
      {required this.id,
      required this.Title,
      required this.Duration,
      required this.Date,
      required this.Time,
      required this.Location,
      required this.no_of_seats,
      required this.cover_photo});
}

class Faculty {
  int id;
  String name;

  Faculty({required this.id, required this.name});
}

class SeminarProfile {
  TextEditingController seminarTitle = TextEditingController();

  void setSeminarTitle(String value) {
    seminarTitle.text = value;
  }

  TextEditingController seminarDuration = TextEditingController();
  TextEditingController seminarDate = TextEditingController();
  TextEditingController seminarLocation = TextEditingController();
  TextEditingController seminarNo_of_seats = TextEditingController();
  TextEditingController seminarTime = TextEditingController();
  File? cover_photo;
  List<Faculty> faculties;
  Faculty? selectedFaculty;

  List<Seminars> seminars;

  SeminarProfile({required this.seminars, required this.faculties});
}

class SeminarProvider extends ChangeNotifier {
  SeminarProfile _seminarProfile = SeminarProfile(seminars: [], faculties: []);

  SeminarProfile get seminarProfile => _seminarProfile;

  Future<void> fetchSeminars() async {
    const String seminarEndpoint = '';
    final String apiUrl = '${ApiConstants.baseUrl}$seminarEndpoint';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> seminarData = json.decode(response.body);
        print(response.body);

        final List<Seminars> fetchedSeminars = seminarData
            .map((seminar) => Seminars(
                id: seminar['facultyID'],
                Title: seminar['Title'],
                Duration: seminar['Duration'],
                Date: seminar['Date'],
                Time: seminar['Time'],
                Location: seminar['Location'],
                no_of_seats: seminar['no_of_seats'],
                cover_photo: seminar['cover_photo']))
            .toList();

        _seminarProfile.seminars = fetchedSeminars;
        notifyListeners();
      } else {
        print("Error fetching faculties. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching faculties: $error");
    }
  }

  Future<void> pickImage(SeminarProfile seminarProfile) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery); // or ImageSource.camera
    if (image != null) {
      seminarProfile.cover_photo = File(image.path);
    }
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
        _seminarProfile.selectedFaculty = fetchedFaculties.first;
        _seminarProfile.faculties = fetchedFaculties;
        notifyListeners();
      } else {
        print("Error fetching faculties. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching faculties: $error");
    }
  }

  Future<List<Seminar>> getSeminarByFaculty(int facultyId) async {
    try {
      final response = await dio.get('/seminar/getseminarbyfaculty/$facultyId');
      if (response.statusCode == 200) {
        List<Seminar> seminars = (response.data as List)
            .map((seminar) => Seminar.fromJson(seminar))
            .toList();
        return seminars;
      } else {
        log("Error fetching seminars. Status code: ${response.statusCode}");
      }
    } catch (error) {
      log("Error fetching seminars: $error");
    }
    return List.empty();
  }
}
