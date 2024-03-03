import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/api_consumer.dart';
import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/api/status_code.dart';
import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/data/cart/model/delete_item_model.dart';
import 'package:fashion_fusion/data/cart/model/put_item_model.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import 'package:dio/dio.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<Unit> deleteCartItems(DeleteCartItemModel model);
  Future<List<CartItemModel>> putCartItems(PutCartItemModel model);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiConsumer apiConsumer;

  CartRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<List<CartItemModel>> getCartItems() async {
    final Response cartItemResponse = await apiConsumer.get(EndPoints.getCartItems);
    if (cartItemResponse.statusCode == StatusCode.ok) {
      try {
        final List<dynamic> jsonList = json.decode(cartItemResponse.data);
        final List<CartItemModel> cartItemModels =
            jsonList.map((json) => CartItemModel.fromJson(json)).toList();

        return cartItemModels;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> deleteCartItems(DeleteCartItemModel model) async {
    final response = await apiConsumer.delete(EndPoints.deleteCartItems,
        body: model.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<List<CartItemModel>> putCartItems(PutCartItemModel model) async {
    final response =
        await apiConsumer.put(EndPoints.putCartItems, body: model.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.data);
      final List<CartItemModel> cartItemModels =
            jsonList.map((json) => CartItemModel.fromJson(json)).toList();

      return Future.value(cartItemModels);
    } else {
      throw const ServerException();
    }
  }
}
