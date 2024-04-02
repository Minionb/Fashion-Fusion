import 'package:intl/intl.dart';

class CustomerDataModel {
  String? sId;
  String? email;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? gender;
  String? telephoneNumber;
  List<Payments>? payments;
  List<Address>? addresses;
  String? address;
  int? iV;

  CustomerDataModel(
      {this.sId,
      this.email,
      this.firstName,
      this.lastName,
      this.address,
      this.dateOfBirth,
      this.gender,
      this.telephoneNumber,
      this.payments,
      this.iV});

  CustomerDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    telephoneNumber = json['telephone_number'];
    if (json['payments'] != null) {
      payments = <Payments>[];
      json['payments'].forEach((v) {
        payments!.add(Payments.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = <Address>[];
      json['addresses'].forEach((v) {
        addresses!.add(Address.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['address'] = address;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['telephone_number'] = telephoneNumber;
    if (payments != null) {
      data['payments'] = payments!.map((v) => v.toJson()).toList();
    }
    data['__v'] = iV;
    return data;
  }
}

class Payments {
  String? name;
  String? method;
  String? cardNumber;
  String? expirationDate;
  String? cvv;
  String? sId;

  Payments(
      {this.method, this.cardNumber, this.expirationDate, this.cvv, this.sId});

  Payments.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    method = json['method'];
    cardNumber = json['cardNumber'];
    expirationDate = formatDate(json['expirationDate']);
    cvv = json['cvv'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['method'] = method;
    data['cardNumber'] = cardNumber;
    data['expirationDate'] = expirationDate;
    data['cvv'] = cvv;
    data['_id'] = sId;
    return data;
  }

  static String formatDate(String dateString) {
    // Parse the input date string
    DateTime dateTime = DateTime.parse(dateString);

    // Format the date to MM/YY format
    String formattedDate = DateFormat('MM/yyyy').format(dateTime);

    return formattedDate;
  }
}

class Address {
  String? addressNickName;
  String? addressLine1;
  String? addressLine2;
  String? zipCode;
  String? city;
  String? country;
  String? sId;

  Address(
      {required this.addressNickName,
      required this.addressLine1,
      this.addressLine2,
      required this.zipCode,
      required this.city,
      required this.country,
      this.sId});

  Address.fromJson(Map<String, dynamic> json) {
    addressNickName = json['addresNickName'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    zipCode = json['zipCode'];
    city = json['city'];
    country = json['country'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sId != null) {
      data['_id'] = sId;
    }
    data['addresNickName'] = addressNickName;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['zipCode'] = zipCode;
    data['city'] = city;
    data['country'] = country;
    return data;
  }
}

class CustomerModel {
  List<CustomerDataModel>? model;

  CustomerModel({this.model});

  CustomerModel.fromJson(List<dynamic> json) {
    model = json.map((e) => CustomerDataModel.fromJson(e)).toList();
  }
}
