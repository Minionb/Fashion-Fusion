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

  static String? cardNumberValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter the card number';
    }

    final RegExp cardNumberRegex = RegExp(r'[0-9]');
    if (!cardNumberRegex.hasMatch(value!)) {
      return 'Card number should contain only numbers';
    }
    if (value.length != 19) {
      return 'Card number must be 16 digits with a space after the 4th, 8th, and 12th digits';
    }
    return null;
  }

  static String? cardExpMonthValidation(String? value, int curMonth) {
    if (value?.isEmpty ?? true) {
      return 'Please enter the card expiration month';
    }

    final RegExp cardNumberRegex = RegExp(r'[0-9]');
    if (!cardNumberRegex.hasMatch(value!)) {
      return 'Card expiration month should contain only numbers';
    }
    if (value.length != 2) {
      return 'Card expiration month must be 2 digits';
    }
    if (12 < int.parse(value) && int.parse(value) < 1) {
      return 'Card expiration month is invalid';
    }

    return null;
  }

  static String? cardExpYearValidation(String? value, int curYear) {

    if (value?.isEmpty ?? true) {
      return 'Please enter the card expiration year';
    }

    final RegExp cardNumberRegex = RegExp(r'[0-9]');
    if (!cardNumberRegex.hasMatch(value!)) {
      return 'Card expiration year should contain only numbers';
    }
    if (value.length != 4) {
      return 'Card expiration year must be 4 digits';
    }

    if (int.parse(value) < curYear) {
      return 'Card is expired';
    }

    return null;
  }

  static String? cardCVVValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter the CVV number';
    }
    final RegExp cardCVVRegex = RegExp(r'[0-9]');
    if (!cardCVVRegex.hasMatch(value!)) {
      return 'Card CVV number should contain only numbers';
    }
    if (value.length != 3) {
      return 'Card CVV number must be 3 digits';
    }
    return null;
  }

  static String? passwordNewValidation(String? password1, String? password2) {
    if (password1?.isEmpty ?? true) {
      return 'Please enter your new password';
    }
    if (password1 == password2) {
      return 'Please edit a new password';
    }
    if (password1!.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? passwordMatchValidation(String? password1, String? password2) {
    if (password1?.isEmpty ?? true) {
      return 'Please enter your new password';
    }
    if (password1 != password2) {
      return 'Passwords do not match';
    }
    return null;
  }
}
