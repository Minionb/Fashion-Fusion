import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/data/customer/model/customer_model.dart';

class OrderModel {
  String? orderId;
  String? customerId;
  List<CartItemModel>? cartItems;
  double? subtotal;
  double? tax;
  double? totalAmount;
  String? status;
  Payments? payment;
  Address? address;
  Delivery? delivery;
  String? createdAt;
  String? updatedAt;

  OrderModel({
    this.orderId,
    this.customerId,
    this.cartItems,
    this.subtotal,
    this.tax,
    this.totalAmount,
    this.status,
    this.payment,
    this.address,
    this.delivery,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'cartItems': cartItems?.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'totalAmount': totalAmount,
      'status': status,
      'payment': payment?.toJson(),
      'address': address?.toJson(),
      'delivery': delivery?.toJson(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? cartItemsJson = json['cartItems'];
    List<CartItemModel>? cartItems =
        cartItemsJson?.map((item) => CartItemModel.fromJson(item)).toList();
    return OrderModel(
      orderId: json['_id'],
      customerId: json['customerId'],
      cartItems: cartItems,
      subtotal: json['subtotal']?.toDouble(),
      tax: json['tax']?.toDouble(),
      totalAmount: json['totalAmount']?.toDouble(),
      status: json['status'],
      payment:
          json['payment'] != null ? Payments.fromJson(json['payment']) : null,
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      delivery:
          json['delivery'] != null ? Delivery.fromJson(json['delivery']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Delivery {
  String? method;
  String? courier;
  String? status;
  String? id;

  Delivery({
    this.method,
    this.courier,
    this.status,
    this.id,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      method: json['method'],
      courier: json['courier'],
      status: json['status'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'courier': courier,
      'status': status,
      '_id': id,
    };
  }
}
