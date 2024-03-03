class PutCartItemModel {
  final String productId;
  final int quantity;

  PutCartItemModel({required this.productId, required this.quantity});


  // Deserialize from JSON
  factory PutCartItemModel.fromJson(Map<String, dynamic> json) {
    return PutCartItemModel(
      productId: json['productId'],
      quantity: json['quantity']
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
    };
    return data;
  }
}

class ResponsePutCartItemModel {
  ResponsePutCartItemModel.fromJson(Map<String, dynamic> json);
}
