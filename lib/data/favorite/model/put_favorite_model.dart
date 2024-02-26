class PutDeleteFavoriteModel {
  final String productId;
  PutDeleteFavoriteModel({required this.productId});


  // Deserialize from JSON
  factory PutDeleteFavoriteModel.fromJson(Map<String, dynamic> json) {
    return PutDeleteFavoriteModel(
      productId: json['productId'],
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

class ResponsePutFavoriteModel {
  ResponsePutFavoriteModel.fromJson(Map<String, dynamic> json);
 
}
