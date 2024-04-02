import 'package:fashion_fusion/data/customer/model/customer_model.dart';
import 'package:intl/intl.dart';

class ProfileModel {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  // Date? dateOfBirth;
  String? gender;
  String? telephoneNumber;
  List<PaymentModel> payments;
  List<Address> addresses;

  ProfileModel(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.telephoneNumber,
      required this.payments,
      required this.addresses});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    var paymentsList = json['payments'] as List<dynamic>;
    List<PaymentModel> payments = paymentsList.map((paymentJson) {
      return PaymentModel.fromJson(paymentJson);
    }).toList();
    var addressList = json['addresses'] as List<dynamic>;
    List<Address> addreses = [];
    if (addressList.isNotEmpty) {
      addreses = addressList.map((address) {
        return Address.fromJson(address);
      }).toList();
    }

    return ProfileModel(
        email: json['email'],
        password: json['password'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        gender: json['gender'],
        telephoneNumber: json['telephone_number'],
        payments: payments,
        addresses: addreses);
  }
}

class PaymentModel {
  final String name;
  final String method;
  final String cardNumber;
  final String expirationDate;
  final String cvv;

  PaymentModel({
    required this.name,
    required this.method,
    required this.cardNumber,
    required this.expirationDate,
    required this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'method': method,
      'cardNumber': cardNumber,
      'expirationDate': expirationDate,
      'cvv': cvv,
    };
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      name: json['name'] ?? '',
      method: json['method'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      expirationDate: formatDate(json['expirationDate'] ?? ''),
      cvv: json['cvv'] ?? '',
    );
  }

  static String formatDate(String dateString) {
    // Parse the input date string
    DateTime dateTime = DateTime.parse(dateString);

    // Format the date to MM/YY format
    String formattedDate = DateFormat('MM/yyyy').format(dateTime);

    return formattedDate;
  }
}
