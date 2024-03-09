import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/api_consumer.dart';
import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/api/status_code.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import '../model/product_model.dart';
import 'package:dio/dio.dart';
import '../model/upload_product_model.dart';
import 'package:http_parser/http_parser.dart';

abstract class ProductRemoteDataSource {
  Future<ProductModel> getProductById(id);
  Future<List<ProductModel>> get();
  Future<ResponseUploadProductModel> add(UploadProductModel model);
  Future<Unit> update(UploadProductModel model);
  Future<Unit> delete(int id);
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
        // await addImage(model.image, decodedJson.productId ?? "");
        return decodedJson;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }
  }

  Future addImage(dynamic imagePath, String productID) async {
    String fileName = imagePath?.path.split('/').last ?? "";
    //! Image PC
    final imagePC = fileName.isEmpty
        ? null
        : await MultipartFile.fromFile(imagePath?.path,
            filename: fileName,
            contentType: MediaType.parse('application/x-www-form-urlencoded'));
    //! Data
    try {
      await apiConsumer.post("${EndPoints.createProduct}/$productID/images",
          formDataIsEnabled: true, body: {"image": imagePC});
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }

    var data = FormData.fromMap({
      'files': [
        await MultipartFile.fromFile(
            '/Users/muayad/Downloads/airbnb_ui_clone-main/assets/images/home.webp',
            filename: 'home.webp')
      ],
    });

    var response = await apiConsumer.post(
      'http://127.0.0.1:3000/products/65ebe7e0b95c6ee3e440a32e/images',
      body: data,
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
    } else {
      print(response.statusMessage);
    }
  }

  @override
  Future<Unit> delete(int id) async {
    final response = await apiConsumer.delete(EndPoints.product);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> update(UploadProductModel model) async {
    final response = await apiConsumer.put(EndPoints.product);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }
}
