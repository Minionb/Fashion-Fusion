
import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';

class OrderListModel {
  String? orderId;
  String? status;
  String? customerId;
  double? totalAmount;
  String? paymentMethod;
  String? deliveryMethod;  
  List<CartItemModel>? cartItems;
  String? createdAt;
  String? updatedAt;

  OrderListModel({
    this.orderId,
    this.status,
    this.customerId,
    this.totalAmount,
    this.paymentMethod,
    this.deliveryMethod,
    this.cartItems,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'status': status,
      'customerId': customerId,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'deliveryMethod': deliveryMethod,
      'cartItems': cartItems,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory OrderListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? cartItemsJson = json['cartItems'];
    List<CartItemModel>? cartItems =
        cartItemsJson?.map((item) => CartItemModel.fromJson(item)).toList();
    return OrderListModel(
      orderId: json['orderId'],
      status: json['status'],
      customerId: json['customerId'],
      totalAmount: json['totalAmount']?.toDouble(),
      paymentMethod: json['paymentMethod'],
      deliveryMethod: json['deliveryMethod'],
      cartItems: cartItems,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
