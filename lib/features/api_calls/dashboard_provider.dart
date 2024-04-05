import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_seminar_search/common/http_helper.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:developer';

class Seminar {
  int seminarId;
  String title;
  double duration;
  String date;
  String time;
  String location;
  int no_of_seats;
  String cover_photo;

  Seminar(
      {required this.seminarId,
      required this.title,
      required this.duration,
      required this.date,
      required this.time,
      required this.no_of_seats,
      required this.location,
      required this.cover_photo});

  factory Seminar.fromJson(Map<String, dynamic> json) {
    return Seminar(
      seminarId: json['seminarID'],
      title: json['title'],
      duration: json['duration'].toDouble(),
      date: json['date'],
      time: json['time'],
      no_of_seats: json['no_of_seats'],
      location: json['location'],
      cover_photo: json['cover_photo'],
    );
  }
}

class Faculty {
  String facultyName;
  int facultyID;

  Faculty({required this.facultyName, required this.facultyID});
  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      facultyName: json['FacultyName'],
      facultyID: json['FacultyID'],
    );
  }
}

class FacultySeminar {
  Faculty faculty;
  List<Seminar> seminars;

  FacultySeminar({required this.faculty, required this.seminars});

  factory FacultySeminar.fromJson(Map<String, dynamic> json) {
    return FacultySeminar(
      faculty: Faculty.fromJson(json['faculty']),
      seminars: (json['seminars'] as List)
          .map((seminar) => Seminar.fromJson(seminar))
          .toList(),
    );
  }
}

class SeminarProfile {
  List<Seminar> seminars;

  SeminarProfile({required this.seminars});
}

class SeminarProfileProvider extends ChangeNotifier {
  SeminarProfile _seminarProfile = SeminarProfile(seminars: []);

  SeminarProfile get seminarProfile => _seminarProfile;

  Future<FacultySeminar> fetchSeminars() async {
    try {
      final response = await dio.get('/user/getuserdashboard');
      if (response.statusCode == 200) {
        FacultySeminar facultySeminar = FacultySeminar.fromJson(response.data);
        return facultySeminar;
      } else {
        log("Error fetching seminars. Status code: ${response.statusCode}");
      }
    } catch (error) {
      log("Error fetching seminars: $error");
    }
    return FacultySeminar(
      faculty: Faculty(facultyName: '', facultyID: 0),
      seminars: [],
    );
  }
}
