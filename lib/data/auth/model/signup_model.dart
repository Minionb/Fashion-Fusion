class RegisterUserModel {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;
  final int? role;

  RegisterUserModel({
    required this.name,
    this.role,
    required this.confirmPassword,
    required this.phone,
    required this.email,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    data['password_confirmation'] = confirmPassword;
    return data;
  }
}
