class ProfileModel {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? address;
  //Date? dateOfBirth;
  String? gender;
  String? telephoneNumber;
  //List? payments;

  ProfileModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.gender,
    required this.telephoneNumber,
    //required this.payments,
  });

  ProfileModel.fromJson(
    Map<String, dynamic> json) {
      email = json['email'];
      password = json['password'];
      firstName = json['first_name'];
      lastName = json['last_name'];
      address = json['address'];
      gender = json['gender'];
      telephoneNumber = json['telephone_number'];
      //payments = json['paymens'];
    }
}
