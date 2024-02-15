class RegisterUserModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String address;
  final String dateOfBirth;
  final Gender gender;

  final String telephoneNumber;

  RegisterUserModel({
    required this.telephoneNumber,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.dateOfBirth,
    required this.gender,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['address'] = address;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender.name;
    data['telephone_number'] = telephoneNumber;

    return data;
  }
}

enum Gender { male, female, other }
