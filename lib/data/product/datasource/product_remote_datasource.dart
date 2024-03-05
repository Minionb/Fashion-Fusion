import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/api_consumer.dart';
import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/api/status_code.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import '../model/product_model.dart';
import 'package:dio/dio.dart';
import '../model/upload_product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> get();
  Future<ResponseUploadProductModel> add(UploadProductModel model);
  Future<Unit> update(UploadProductModel model);
  Future<Unit> delete(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProductRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<List<ProductModel>> get() async {

    final Response response = await apiConsumer.get(EndPoints.getProducts);
    if (response.statusCode == StatusCode.ok) {
      try {
        final List<dynamic> jsonList = json.decode(response.data);
        final List<ProductModel> decodedJson =
            jsonList.map((json) =>  ProductModel.fromJson(json)).toList();
        return decodedJson;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }

  }

  @override
  Future<ResponseUploadProductModel> add(UploadProductModel model) async{
     final response = await apiConsumer
        .post(EndPoints.postProducts);
    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final ResponseUploadProductModel decodedJson =
            ResponseUploadProductModel.fromJson(json.decode(response.data));
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
        .delete(EndPoints.product);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> update(UploadProductModel model) async{
  final response = await apiConsumer
        .put(EndPoints.product);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }
}