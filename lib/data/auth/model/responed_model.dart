class ResponseModel {
  String? accessToken;
  String? refreshToken;

  ResponseModel({this.accessToken, this.refreshToken});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }
}
