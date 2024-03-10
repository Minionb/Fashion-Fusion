import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/api_consumer.dart';
import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/api/status_code.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/product_model.dart';
import 'package:dio/dio.dart';
import '../model/upload_product_model.dart';

import "package:http/http.dart" as http;

abstract class ProductRemoteDataSource {
  Future<ProductModel> getProductById(id);
  Future<List<ProductModel>> get();
  Future<ResponseUploadProductModel> add(UploadProductModel model);
  Future<Unit> update(UploadProductModel model);
  Future<Unit> delete(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProductRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ProductModel> getProductById(id) async {
    final Response response = await apiConsumer.get(EndPoints.getProductsById);
    if (response.statusCode == StatusCode.ok) {
      try {
        final ProductModel decodedJson =
            ProductModel.fromJson(json.decode(response.data));
        return decodedJson;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<List<ProductModel>> get() async {
    final Response response = await apiConsumer.get(EndPoints.getProducts);
    if (response.statusCode == StatusCode.ok) {
      try {
        final List<dynamic> jsonList = json.decode(response.data);
        final List<ProductModel> decodedJson =
            jsonList.map((json) => ProductModel.fromJson(json)).toList();
        return decodedJson;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<ResponseUploadProductModel> add(UploadProductModel model) async {
    final response =
        await apiConsumer.post(EndPoints.createProduct, body: model.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final ResponseUploadProductModel decodedJson =
            ResponseUploadProductModel.fromJson(json.decode(response.data));
        model.image != null
            ? await uploadImage(
                model.image?.path ?? "", decodedJson.productId ?? "")
            : null;

        return decodedJson;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }
  }

  uploadImage(String imagePath, String productID) async {
    var headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': sl<SharedPreferences>().getString("token") ?? ""
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${EndPoints.createProduct}/$productID/images'));
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  @override
  Future<Unit> delete(String id) async {
    final Response response =
        await apiConsumer.delete("${EndPoints.createProduct}/$id");

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> update(UploadProductModel model) async {
    final response = await apiConsumer.put(EndPoints.createProduct);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }
}
