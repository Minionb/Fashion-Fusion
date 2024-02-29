import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/api_consumer.dart';
import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/api/status_code.dart';
import 'package:fashion_fusion/data/favorite/model/put_favorite_model.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import '../model/favorite_model.dart';
import 'package:dio/dio.dart';

abstract class FavoriteRemoteDataSource {
  Future<FavoriteModel> get();
  Future<Unit> put(PutDeleteFavoriteModel model);
  Future<Unit> delete(PutDeleteFavoriteModel model);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final ApiConsumer apiConsumer;

  FavoriteRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<FavoriteModel> get() async {
    final Response response = await apiConsumer.get(EndPoints.getFavoriteItems);
    if (response.statusCode == StatusCode.ok) {
      try {
        final jsonData = json.decode(response.data);
        return FavoriteModel.fromJson(jsonData);
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> delete(PutDeleteFavoriteModel model) async {
    final response = await apiConsumer.delete(EndPoints.deleteFavoriteItems,
        body: model.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> put(PutDeleteFavoriteModel model) async {
    final response =
        await apiConsumer.put(EndPoints.putFavoriteItems, body: model.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }
}
