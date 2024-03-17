import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => 'http://10.0.1.7:8080';
  static const String contentType = 'application/json';
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String isHost = 'isHost';
}
