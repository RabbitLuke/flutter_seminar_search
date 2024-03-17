import 'package:flutter_seminar_search/constants.dart';
import 'package:dio/dio.dart';

late Dio dio;

initDio() {
  BaseOptions options = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    contentType: ApiConstants.contentType,
  );
  dio = Dio(options);
}