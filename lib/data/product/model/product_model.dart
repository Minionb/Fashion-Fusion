class ProductModel {
  String? id;
  String? productName;
  String? category;
  String? productDescription;
  double? price;
  String? tags;
  int? soldQuantity;
  List<InventoryModel>? inventory;
  List<String>? images;
  String? createdBy;
  String? createdAt;
  String? updatedAt;

  ProductModel({
    required this.id,
    required this.productName,
    required this.category,
    required this.productDescription,
    required this.price,
    required this.tags,
    required this.soldQuantity,
    required this.inventory,
    required this.images,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

   ProductModel.fromJson(Map<String, dynamic> json) {
    
      id = json['_id'];
      productName = json['product_name'];
      category = json['category'];
      productDescription = json['product_description'];
      price = json['price'].toDouble();
      tags = json['tags'];
      soldQuantity = json['sold_quantity'];
      inventory = List<InventoryModel>.from(
        json['inventory'].map((inventoryJson) => InventoryModel.fromJson(inventoryJson)),
      );
      images = List<String>.from(json['images']);
      createdBy = json['createdBy'];
      createdAt = json['createdAt'];
      updatedAt = json['updatedAt'];

  
  }
}

class InventoryModel {
  String? size;
  int? quantity;
  String? id;

  InventoryModel({
    required this.size,
    required this.quantity,
    required this.id,
  });

   InventoryModel.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    quantity = json['quantity'];
    id = json['_id'];
  }
}