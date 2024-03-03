class EndPoints {
  static const String baseUrl = 'http://127.0.0.1:3000';
  static const String customerUrl = '$baseUrl/customers';
  static const String adminUrl = '$baseUrl/admins';

  // Auth
  static const String login = '$customerUrl/login';
  static const String adminLogin = "$adminUrl/login";
  static const String signup = '$customerUrl/register';
  static const String profile = '$customerUrl/';
  static const String product = '$customerUrl/product';

  // Products
  static const String productResourcePath = '$baseUrl/products';
  static const String postProducts = '$productResourcePath?';
  static const String getProducts = '$productResourcePath?';
  static const String getProductsById = '$productResourcePath/:productId';
  static const String deleteProductsById = '$productResourcePath/:productId';
  static const String putProductsById = getProductsById;
  static const String postProductImagesForProductId =
      '$productResourcePath/:productId/images';
  static const String getProductImagesByImageId =
      '$productResourcePath/images/:imageId';
  static const String deleteProductImagesByImageId =
      '$productResourcePath/images/:imageId';

  // Favorites
  static const String favoriteResourcePath = '$baseUrl/favorite/items';
  static const String getFavoriteItems = favoriteResourcePath;
  static const String putFavoriteItems = favoriteResourcePath;
  static const String deleteFavoriteItems = favoriteResourcePath;

  // Carts
  static const String cartResourcePath = '$baseUrl/cart/items';
  static const String putCartItems = cartResourcePath;
  static const String getCartItems = cartResourcePath;
  static const String deleteCartItems = cartResourcePath;
  static const String deleteCartItemsById = '$cartResourcePath/:productId';

  // Orders
  static const String postCheckout = '$baseUrl/checkout';
  static const String orderResourcePath = '$baseUrl/orders';
  static const String getOrdersById = '$orderResourcePath/:orderId';
  static const String patchOrdersById = '$orderResourcePath/:orderId';

  // Customers
  static const String customer = '$baseUrl/customers';
}
