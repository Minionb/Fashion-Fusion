import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/api_consumer.dart';
import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/api/status_code.dart';
import 'package:fashion_fusion/error/exceptions.dart';

import '../model/customer_model.dart';
import 'package:dio/dio.dart';

import '../model/upload_customer_model.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerModel> getCustomers();
  Future<CustomerDataModel> getCustomerById(String customerId);
  Future<ResponseUploadCustomerModel> add(UploadCustomerModel model);
  Future<Unit> update(UploadCustomerModel model);
  Future<Unit> delete(int id);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final ApiConsumer apiConsumer;

  CustomerRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<CustomerDataModel> getCustomerById(String customerId) async {
    final Response response = await apiConsumer.get(EndPoints.getCustomerById.replaceAll(":customerId", customerId));
    if (response.statusCode == StatusCode.ok) {
      try {
        final CustomerDataModel decodedJson =
            CustomerDataModel.fromJson(json.decode(response.data));
        return decodedJson;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<CustomerModel> getCustomers() async {

    final Response response = await apiConsumer.get(EndPoints.customer);
    if (response.statusCode == StatusCode.ok) {
      try {
        final CustomerModel decodedJson =
            CustomerModel.fromJson(json.decode(response.data));
        return decodedJson;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }

  }

  @override
  Future<ResponseUploadCustomerModel> add(UploadCustomerModel model) async{
     final response = await apiConsumer
        .post(EndPoints.customer);
    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final ResponseUploadCustomerModel decodedJson =
            ResponseUploadCustomerModel.fromJson(json.decode(response.data));
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
        .delete(EndPoints.customer);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> update(UploadCustomerModel model) async{
  final response = await apiConsumer
        .put(EndPoints.customer);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }
}