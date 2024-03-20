import 'package:dio/dio.dart';

abstract class ApiConsumer {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<dynamic> post(String path,
      {dynamic body,
      Options? options,
      Map<String, dynamic>? queryParameters,
      bool formDataIsEnabled = false});
  Future<dynamic> delete(String path,
      {dynamic body, Map<String, dynamic>? queryParameters});
  Future<dynamic> put(String path,
      {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters});

  Future<dynamic> patch(String path,
      {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters});



}
