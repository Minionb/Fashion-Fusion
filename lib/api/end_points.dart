class EndPoints {
  static const String baseUrl = 'http://127.0.0.1:3000';
  static const String customerUrl = '$baseUrl/customers';
  static const String adminUrl = '$baseUrl/admins';

  //
  static const String login = '$customerUrl/login';
  static const String adminLogin = "$adminUrl/login";
  static const String signup = '$customerUrl/register';
  static const String profile = '$customerUrl/';
  static const String product = '$customerUrl/product';

  // Favorites
  static const String favoriteResourcePath = '$baseUrl/favorite/items';
  static const String getFavoriteItems = favoriteResourcePath;
  static const String putFavoriteItems = favoriteResourcePath;
  static const String deleteFavoriteItems = favoriteResourcePath;

}
