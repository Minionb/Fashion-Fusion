import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:flutter/foundation.dart';


import 'package:shared_preferences/shared_preferences.dart';

class AppIntercepters extends Interceptor {
  @override
  void onRequest(options, handler) {
    String? accessToken = sl<SharedPreferences>().getString("accessToken");
    if (accessToken != '') {
      options.headers['authorization'] = accessToken;
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
