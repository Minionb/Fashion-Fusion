import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_string.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData appTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
      ),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.grey),
      primaryTextTheme: Typography(platform: TargetPlatform.iOS).black,
      textTheme: Typography(platform: TargetPlatform.iOS).black,
      scaffoldBackgroundColor: AppColors.bg,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      fontFamily: AppString.fontFamily,
    );
  }

  static ButtonStyle primaryButtonStyle(){
    return ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              textStyle: const TextStyle(fontSize: 18),
            );
  }
  static ButtonStyle disabledButtonStyle(){
    return ElevatedButton.styleFrom(
              backgroundColor: AppColors.disabled,
              textStyle: const TextStyle(fontSize: 18),
            );
  }

  static ThemeData appThemeDark() {
    return ThemeData(
      appBarTheme: AppBarTheme(backgroundColor: AppColors.bgDK),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.grey),
      primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
      textTheme: Typography(platform: TargetPlatform.iOS).white,
      scaffoldBackgroundColor: AppColors.bgDK,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryDK,
      fontFamily: AppString.fontFamily,
    );
  }
}
