class FavoriteDataModel {
  String? productId;
  double? price;
  String? productName;
  String? imageId;
  bool? isFavorite;

  FavoriteDataModel({this.productId, this.price, this.productName});

  FavoriteDataModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    price = json['price'];
    productName = json['productName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['price'] = price;
    data['productName'] = productName;
    return data;
  }
}

class FavoriteModel {
  List<FavoriteDataModel>? model;

  FavoriteModel({this.model});

  FavoriteModel.fromJson(List<dynamic> json) {
    model = json.map((e) => FavoriteDataModel.fromJson(e)).toList();
  }
}

