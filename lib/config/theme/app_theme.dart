import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_string.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData appTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(backgroundColor: AppColors.bg),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.grey),
      scaffoldBackgroundColor: AppColors.bg,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      fontFamily: AppStrings.fontFamily,
    );
  }
}
