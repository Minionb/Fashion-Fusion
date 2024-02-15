class Status {
  bool? success;
  Error? error;

  Status({this.success, this.error});

  Status.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}

class Error {
  List<dynamic>? name;
  List<dynamic>? goalId;
  List<dynamic>? interestId;
  List<dynamic>? phone;
  List<dynamic>? weight;
  List<dynamic>? height;
  List<dynamic>? age;
  List<dynamic>? email;
  List<dynamic>? password;

  Error(
      {this.name,
      this.goalId,
      this.interestId,
      this.phone,
      this.weight,
      this.height,
      this.age,
      this.email,
      this.password});

  Error.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    goalId = json['goal_id'];
    interestId = json['interest_id'];
    phone = json['phone'];
    weight = json['weight'];
    height = json['height'];
    age = json['age'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['goal_id'] = goalId;
    data['interest_id'] = interestId;
    data['phone'] = phone;
    data['weight'] = weight;
    data['height'] = height;
    data['age'] = age;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}

// class Error {
//   List<dynamic>? phone;
//   List<dynamic>? email;

//   Error({this.phone, this.email});

//   Error.fromJson(Map<String, dynamic> json) {
//     phone = json['phone'];
//     email = json['email'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['phone'] = phone;
//     data['email'] = email;
//     return data;
//   }
// }
