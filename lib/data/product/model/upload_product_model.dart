import 'dart:io';

class UploadProductModel {
  final String productName;
  final String category;
  final String productDescription;
  final double price;
  final String tags;
  final int soldQuantity;
  File? image;
  List<Inventory>? inventory;

  UploadProductModel(
      {required this.productName,
      required this.category,
      this.image,
      required this.productDescription,
      required this.price,
      required this.tags,
      required this.soldQuantity,
      this.inventory});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['category'] = category;
    data['product_description'] = productDescription;
    data['price'] = price;
    data['tags'] = tags;
    data['sold_quantity'] = soldQuantity;
    // if (inventory != null) {
    //   data['inventory'] = inventory!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Inventory {
  String? size;
  int? quantity;

  Inventory({this.size, this.quantity});

  Inventory.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['size'] = size;
    data['quantity'] = quantity;
    return data;
  }
}

class ResponseUploadProductModel {
  String? productId;
  String? message;

  ResponseUploadProductModel({this.productId, this.message});

  ResponseUploadProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['message'] = message;
    return data;
  }
}
