import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_seminar_search/common/http_helper.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  AuthService() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        //log(options.data.toString(), name: 'onRequest');
        final accessToken =
            await storage.read(key: ApiConstants.accessTokenKey);
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        //log(response.toString(), name: 'onResponse');
        return handler.next(response);
      },
      onError: (DioError error, handler) async {
        // Check for token expired error
        //log(error.toString(), name: 'onError');
        if (error.response?.statusCode == 401) {
          refreshAccessToken();
        }

        return handler.next(error);
      },
    ));
  }

  Future<bool> authenticate(String email, String password) async {
    try {
      final response = await dio.post(
        '/authenticate',
        data: {'Email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['token'];
        final refreshToken = data['refresh_token'];

        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

        bool isHost = decodedToken['IsHost'];

        await storage.write(key: ApiConstants.isHost, value: isHost.toString());
        await storage.write(
            key: ApiConstants.accessTokenKey, value: accessToken);
        await storage.write(
            key: ApiConstants.refreshTokenKey, value: refreshToken);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> refreshAccessToken() async {
    final refreshToken = await storage.read(key: ApiConstants.refreshTokenKey);
    if (refreshToken != null) {
      try {
        final response = await dio.post(
          '/refresh-token',
          data: {'refresh_token': refreshToken},
        );

        final accessToken = response.data['access_token'];
        if (accessToken != null) {
          await storage.write(
              key: ApiConstants.accessTokenKey, value: accessToken);
          return;
        }
      } catch (e) {
        print('Failed to refresh access token: $e');
      }
    }

    // Clear stored tokens if refresh token is invalid or refresh request fails
    await storage.delete(key: ApiConstants.accessTokenKey);
    await storage.delete(key: ApiConstants.refreshTokenKey);
    await storage.delete(key: ApiConstants.isHost);
  }

  Future<void> logout() async {
    await storage.delete(key: ApiConstants.accessTokenKey);
    await storage.delete(key: ApiConstants.refreshTokenKey);
    await storage.delete(key: ApiConstants.isHost);
  }
}
