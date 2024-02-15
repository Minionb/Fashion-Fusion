import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fashion_fusion/api/api_consumer.dart';
import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/api/status_code.dart';
import 'package:fashion_fusion/data/auth/model/login_model.dart';
import 'package:fashion_fusion/data/auth/model/responed_model.dart';
import 'package:fashion_fusion/data/auth/model/signup_model.dart';
import 'package:fashion_fusion/data/auth/model/status_model.dart';
import 'package:fashion_fusion/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<ResponseModel> login(LoginModel model);
  Future<Status> register(RegisterUserModel model);
  Future<Unit> logout();
  Future<Unit> forgetPassword();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<ResponseModel> login(LoginModel model) async {
    final Response response =
        await apiConsumer.post(EndPoints.login, body: model.toJson());
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final jsonData = json.decode(response.data);
      return ResponseModel.fromJson(jsonData);
    } else {
      String jsonsDataString = response.toString();
      final jsonData = jsonDecode(jsonsDataString);
      throw ServerException(jsonData["message"]);
    }
  }

  @override
  Future<Status> register(RegisterUserModel model) async {
    final Response response = await apiConsumer.post(
      EndPoints.signup,
      body: model.toJson(),
    );
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final jsonData = json.decode(response.data);
      return Status.fromJson(jsonData);
    } else {
      String jsonDataString = response.toString();
      final jsonData = jsonDecode(jsonDataString);
      throw ServerException(jsonData["message"]);
    }
  }

  @override
  Future<Unit> logout() async {
    throw UnimplementedError();
  }

  @override
  Future<Unit> forgetPassword() async {
    throw UnimplementedError();
  }
}
