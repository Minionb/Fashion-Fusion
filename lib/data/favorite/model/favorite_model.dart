class FavoriteModel {
  String? id;
  double? price;
  String? productName;

  FavoriteModel({
    required this.id,
    required this.price,
    required this.productName,
  });

   FavoriteModel.fromJson(Map<String, dynamic> json) {
    
      id = json['_id'];
      price = json['price'];
      productName = json['productName'];  
  }
}