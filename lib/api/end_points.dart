class EndPoints {
  static const String baseUrl = 'https://secsysolutions.herokuapp.com/en/api';

  //
  static const String login = '$baseUrl/login/';
  static const String signup = '$baseUrl/register/';
  static const String logout = '$baseUrl/logout/';
  static const String emergCall = '$baseUrl/emerg-call';
  static const String qr = '$baseUrl/qr/';
  static const String gate = '$baseUrl/gate/';

  static const String userToken = '$baseUrl/token-auth/';
  static const String userDetails = '$baseUrl/details-user';
  static const String userLocation = '$baseUrl/update-user-loc';
}
