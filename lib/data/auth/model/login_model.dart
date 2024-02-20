class LoginModel {
  final String email;
  final String password;
  final bool isAdmin;

  LoginModel(
      {required this.email, required this.password, this.isAdmin = false});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
