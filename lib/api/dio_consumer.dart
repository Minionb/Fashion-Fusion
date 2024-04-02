import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fashion_fusion/api/app_interceptors.dart';
import 'package:fashion_fusion/api/status_code.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:flutter/foundation.dart';

import '../error/exceptions.dart';
import 'api_consumer.dart';
import 'end_points.dart';

class DioConsumer implements ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    (client.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    client.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..receiveDataWhenStatusError = true
      ..headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      }
      ..validateStatus = (status) {
        return status! < StatusCode.internalServerError;
      };
    client.interceptors.add(sl<AppIntercepters>());
    if (kDebugMode) {
      client.interceptors.add(sl<LogInterceptor>());
    }
  }

  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await client.get(path,
          queryParameters: queryParameters, options: options);
      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future post(String path,
      {dynamic body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    try {
      var jsonBody = utf8.encode(json.encode(body));
      final response = await client.post(path,
          queryParameters: queryParameters,
          options: options ??
              Options(
                  headers: {HttpHeaders.contentTypeHeader: "application/json"}),
          data: formDataIsEnabled ? FormData.fromMap(body!) : jsonBody);

      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future put(String path,
      {dynamic body, Map<String, dynamic>? queryParameters}) async {
    try {
      var jsonBody = utf8.encode(json.encode(body));
      final response = await client.put(path,
          queryParameters: queryParameters,
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}),
          data: jsonBody);

      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future patch(String path,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      var jsonBody = utf8.encode(json.encode(body));
      final response = await client.patch(path,
          queryParameters: queryParameters,
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}),
          data: jsonBody);

      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future delete(String path,
      {dynamic body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters}) async {
    try {
      var options =
          Options(headers: {HttpHeaders.contentTypeHeader: "application/json"});

      // Check if body is null or empty
      if (body != null && body.isNotEmpty) {
        // Encode the body to JSON if it's not null or empty
        var jsonBody = json.encode(body);
        options = Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"},
        );

        if (formDataIsEnabled) {
          await client.delete(path,
              queryParameters: queryParameters,
              options: options,
              data: FormData.fromMap(body));
          return;
        } else {
          await client.delete(path,
              queryParameters: queryParameters,
              options: options,
              data: jsonBody);
          return;
        }
      } else {
        // If body is null or empty, simply make the delete request without data
        final response = await client.delete(path,
            queryParameters: queryParameters, options: options);
        return response;
      }
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  dynamic _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const FetchDataException();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case StatusCode.badRequest:
            throw const BadRequestException();
          case StatusCode.unauthorized:
          case StatusCode.forbidden:
            throw const UnauthorizedException();
          case StatusCode.notFound:
            throw const NotFoundException();
          case StatusCode.confilct:
            throw const ConflictException();

          case StatusCode.internalServerError:
            throw const InternalServerErrorException();
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        throw const NoInternetConnectionException();
      case DioExceptionType.badCertificate:
        throw const NoInternetConnectionException();

      case DioExceptionType.connectionError:
        throw const NoInternetConnectionException();
    }
  }
}
