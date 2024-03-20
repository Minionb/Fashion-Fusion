class AdminOrderUpdateStatusModel {
  String? orderID;
  String? orderStatus;
  Payment? payment;
  Delivery? delivery;

  AdminOrderUpdateStatusModel(
      {this.orderStatus, this.payment, this.delivery, this.orderID});

  AdminOrderUpdateStatusModel.fromJson(Map<String, dynamic> json) {
    orderStatus = json['orderStatus'];
    payment =
        json['payment'] != null ? Payment.fromJson(json['payment']) : null;
    delivery =
        json['delivery'] != null ? Delivery.fromJson(json['delivery']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = orderStatus;
    return data;
  }
}

class Payment {
  String? method;
  String? cardNumber;
  String? status;

  Payment({this.method, this.cardNumber, this.status});

  Payment.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    cardNumber = json['cardNumber'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method'] = method;
    data['cardNumber'] = cardNumber;
    data['status'] = status;
    return data;
  }
}

class Delivery {
  String? method;
  String? courier;
  String? status;

  Delivery({this.method, this.courier, this.status});

  Delivery.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    courier = json['courier'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method'] = method;
    data['courier'] = courier;
    data['status'] = status;
    return data;
  }
}

class AdminOrderUpdateStatusResponse {
  String? message;
  Order? order;

  AdminOrderUpdateStatusResponse({this.message, this.order});

  AdminOrderUpdateStatusResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Order {
  String? sId;
  String? customerId;
  List<CartItems>? cartItems;
  String? status;
  Payment? payment;
  Address? address;
  Delivery? delivery;
  num? subtotal;
  num? tax;
  num? totalAmount;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Order(
      {this.sId,
      this.customerId,
      this.cartItems,
      this.status,
      this.payment,
      this.address,
      this.delivery,
      this.subtotal,
      this.tax,
      this.totalAmount,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Order.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    customerId = json['customerId'];
    if (json['cartItems'] != null) {
      cartItems = <CartItems>[];
      json['cartItems'].forEach((v) {
        cartItems!.add(CartItems.fromJson(v));
      });
    }
    status = json['status'];
    payment =
        json['payment'] != null ? Payment.fromJson(json['payment']) : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    delivery =
        json['delivery'] != null ? Delivery.fromJson(json['delivery']) : null;
    subtotal = json['subtotal'];
    tax = json['tax'];
    totalAmount = json['totalAmount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['customerId'] = customerId;
    if (cartItems != null) {
      data['cartItems'] = cartItems!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (delivery != null) {
      data['delivery'] = delivery!.toJson();
    }
    data['subtotal'] = subtotal;
    data['tax'] = tax;
    data['totalAmount'] = totalAmount;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class CartItems {
  String? productId;
  num? quantity;
  num? price;
  String? sId;

  CartItems({this.productId, this.quantity, this.price, this.sId});

  CartItems.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['_id'] = sId;
    return data;
  }
}

class Address {
  String? addressLine1;
  String? addressLine2;
  String? zipCode;
  String? city;
  String? country;
  String? sId;

  Address(
      {this.addressLine1,
      this.addressLine2,
      this.zipCode,
      this.city,
      this.country,
      this.sId});

  Address.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    zipCode = json['zipCode'];
    city = json['city'];
    country = json['country'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['zipCode'] = zipCode;
    data['city'] = city;
    data['country'] = country;
    data['_id'] = sId;
    return data;
  }
}
