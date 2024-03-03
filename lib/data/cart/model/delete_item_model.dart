class DeleteCartItemModel {
  final String productId;

  DeleteCartItemModel({required this.productId});


  // Deserialize from JSON
  factory DeleteCartItemModel.fromJson(Map<String, dynamic> json) {
    return DeleteCartItemModel(
      productId: json['productId']
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'productId': productId,
    };
    return data;
  }
}

class ResponseDeleteCartItemModel {
  ResponseDeleteCartItemModel.fromJson(Map<String, dynamic> json);
}
