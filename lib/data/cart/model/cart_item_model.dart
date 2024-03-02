class CartItemModel {
  String? productId;
  double? price;
  String? productName;
  String? imageId;
  bool? isFavorite;

  CartItemModel({
    required this.productId,
    required this.price,
    required this.productName,
    required this.imageId,
    isFavorite = true
  });

   CartItemModel.fromJson(Map<String, dynamic> json) {
      productId = json['productId'];
      price = json['price'];
      productName = json['productName'];  
      imageId = json['imageId'];
  }
}

