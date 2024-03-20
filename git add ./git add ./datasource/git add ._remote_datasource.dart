import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../core/api/api_consumer.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/api/end_points.dart';
import '../model/git add ._model.dart';
import 'package:dio/dio.dart';
import '../../../core/api/status_code.dart';
import '../model/upload_git add ._model.dart';

abstract class gitAddRemoteDataSource {
  Future<gitAddModel> get();
  Future<ResponseUploadgitAddModel> add(UploadgitAddModel model);
  Future<Unit> update(UploadgitAddModel model);
  Future<Unit> delete(int id);
}

class gitAddRemoteDataSourceImpl implements gitAddRemoteDataSource {
  final ApiConsumer apiConsumer;

  gitAddRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<gitAddModel> get() async {
  static const String git add . = '${mobileAPI}git add .';

    final Response response = await apiConsumer.get(EndPoints.git add .);
    if (response.statusCode == StatusCode.ok) {
      try {
        final gitAddModel decodedJson =
            gitAddModel.fromJson(json.decode(response.data));
        return decodedJson;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }

  }

  @override
  Future<ResponseUploadgitAddModel> add(UploadgitAddModel model) async{
     final response = await apiConsumer
        .post(EndPoints.git add .);
    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final ResponseUploadgitAddModel decodedJson =
            ResponseUploadgitAddModel.fromJson(json.decode(response.data));
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
        .delete(EndPoints.git add .);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> update(UploadgitAddModel model) async{
  final response = await apiConsumer
        .put(EndPoints.git add .);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }
}