class CartItemModel {
  String? productId;
  int? quantity;
  double? price;
  String? productName;
  String? imageId;

  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
    required this.imageId,
  });

  CartItemModel.fromJson(Map<String, dynamic> json)
      : productId = json['productId'],
        quantity = json['quantity'],
        price = json['price'].toDouble(), // Parse to double
        productName = json['productName'],
        imageId = json['imageId']; // Handle nullable bool

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'productName': productName,
      'imageId': imageId,
    };
  }
}
