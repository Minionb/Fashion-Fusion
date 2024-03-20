class AdminOrderModel {
  String? orderId;
  String? status;
  double? totalAmount;
  String? paymentMethod;
  String? deliveryMethod;
  String? createdAt;
  String? updatedAt;

  AdminOrderModel(
      {this.orderId,
      this.status,
      this.totalAmount,
      this.paymentMethod,
      this.deliveryMethod,
      this.createdAt,
      this.updatedAt});

  AdminOrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    status = json['status'];
    totalAmount = json['totalAmount'];
    paymentMethod = json['paymentMethod'];
    deliveryMethod = json['deliveryMethod'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['status'] = status;
    data['totalAmount'] = totalAmount;
    data['paymentMethod'] = paymentMethod;
    data['deliveryMethod'] = deliveryMethod;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
