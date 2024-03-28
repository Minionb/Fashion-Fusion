class SetPasswordModel {
  final String oldPassword;
  final String password;

  SetPasswordModel({
    required this.oldPassword,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oldPassword'] = oldPassword;
    data['password'] = password;
    return data;
  }
}