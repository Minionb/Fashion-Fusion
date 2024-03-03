class CustomerDataModel {
  String? sId;
  String? email;
  String? firstName;
  String? lastName;
  String? address;
  String? dateOfBirth;
  String? gender;
  String? telephoneNumber;
  List<Payments>? payments;
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
  String? method;
  String? cardNumber;
  String? expirationDate;
  String? cvv;
  String? sId;

  Payments(
      {this.method, this.cardNumber, this.expirationDate, this.cvv, this.sId});

  Payments.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    cardNumber = json['cardNumber'];
    expirationDate = json['expirationDate'];
    cvv = json['cvv'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method'] = method;
    data['cardNumber'] = cardNumber;
    data['expirationDate'] = expirationDate;
    data['cvv'] = cvv;
    data['_id'] = sId;
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
