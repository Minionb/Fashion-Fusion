import 'dart:convert';
import 'package:fashion_fusion/api/api_consumer.dart';
import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/api/status_code.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/data/cart/model/put_item_model.dart';
import 'package:fashion_fusion/data/order/model/order_model.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrderByCustomerId();
  Future<OrderModel> postOrderCheckout(OrderModel model);
  Future<List<OrderModel>> getOrders();
  Future<List<CartItemModel>> patchOrder(PutCartItemModel model);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiConsumer apiConsumer;

  OrderRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<List<OrderModel>> getOrderByCustomerId() async {
    sl<SharedPreferences>().getString("userID")!;
    final Response orderResponse =
        await apiConsumer.get(EndPoints.getOrdersByCustomerId);
    if (orderResponse.statusCode == StatusCode.ok) {
      try {
        final List<dynamic> jsonList = json.decode(orderResponse.data);
        final List<OrderModel> orderItemModels =
            jsonList.map((json) => OrderModel.fromJson(json)).toList();

        return orderItemModels;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    sl<SharedPreferences>().getString("userID")!;
    final Response orderResponse =
        await apiConsumer.get(EndPoints.getOrdersByCustomerId);
    if (orderResponse.statusCode == StatusCode.ok) {
      try {
        final List<dynamic> jsonList = json.decode(orderResponse.data);
        final List<OrderModel> orderItemModels =
            jsonList.map((json) => OrderModel.fromJson(json)).toList();

        return orderItemModels;
      } catch (e) {
        throw const FetchDataException();
      }
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<List<CartItemModel>> patchOrder(PutCartItemModel model) async {
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

  @override
  Future<OrderModel> postOrderCheckout(OrderModel model) async {
    final response = await apiConsumer.post(EndPoints.postOrdersCheckout,
        body: model.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> jsonList = json.decode(response.data);
      final OrderModel orderModel = OrderModel.fromJson(jsonList);

      return Future.value(orderModel);
    } else {
      throw const ServerException();
    }
  }
}