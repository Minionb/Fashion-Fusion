class FavoriteModel {
  String productId;
  double price;
  String productName;
  String imageId;
  bool? isFavorite;

  FavoriteModel({
    required this.productId,
    required this.price,
    required this.productName,
    required this.imageId,
    isFavorite = true
  });

   FavoriteModel.fromJson(Map<String, dynamic> json) 
      : productId = json['productId'],
        price = json['price'].toDouble(),
        productName = json['productName'],
        imageId = json['imageId'];
}

