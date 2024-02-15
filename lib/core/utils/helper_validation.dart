import 'package:fashion_fusion/core/utils/email_extension.dart';

class ValidationHelper {
  static String? usernameValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter a username';
    }

    final RegExp usernameRegex = RegExp(r'^[\w.@+-]{1,150}$');
    if (!usernameRegex.hasMatch(value!)) {
      return 'Username should contain only letters, numbers, or symbols @/./+/-/_';
    }

    return null;
  }

  static String? firstNameValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter the first name';
    }
    return null;
  }

  static String? secondNameValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter the last name';
    }
    return null;
  }

  static String? passwordValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter the password';
    }
    if (value!.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? emailValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter the email';
    }
    if (!value!.isValidEmail()) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordConfirmationValidation(
      String? value, String? password) {
    if (value?.isEmpty ?? true) {
      return 'Please enter password confirmation';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? phoneNumberValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter the phone number';
    }
    final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value!)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? addressValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter the address';
    }

    return null;
  }
}
