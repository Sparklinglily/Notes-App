import 'package:note_app/core/constants/app_strings.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }

    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.titleRequired;
    }

    return null;
  }

  static String? validateContent(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.contentRequired;
    }

    return null;
  }
}
