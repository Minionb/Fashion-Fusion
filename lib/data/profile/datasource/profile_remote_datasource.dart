import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/api_consumer.dart';
import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/api/status_code.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import '../model/profile_model.dart';
import 'package:dio/dio.dart';

import '../model/upload_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> get(String userID);
  Future<ResponseUploadProfileModel> add(UploadProfileModel model);
  Future<Unit> update(UploadProfileModel model);
  Future<Unit> delete(int id);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProfileRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<ProfileModel> get(String userID) async {

    final Response response = await apiConsumer.get(EndPoints.profile + userID);
    if (response.statusCode == StatusCode.ok) {
      try {
        final ProfileModel decodedJson =
            ProfileModel.fromJson(json.decode(response.data));
        return decodedJson;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }

  }

  @override
  Future<ResponseUploadProfileModel> add(UploadProfileModel model) async{
    final response = await apiConsumer
        .post(EndPoints.profile);
    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final ResponseUploadProfileModel decodedJson =
            ResponseUploadProfileModel.fromJson(json.decode(response.data));
        return decodedJson;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> delete(int id) async{
  final response = await apiConsumer
        .delete(EndPoints.profile);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> update(UploadProfileModel model) async{
  final response = await apiConsumer
        .put(EndPoints.profile);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }
}