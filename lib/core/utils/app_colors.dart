import 'package:flutter/material.dart';

class AppColors {
  // You can chnage colors depends
  static Color primary = HexColor("DB3022");
  static Color bg = HexColor("#F9F9F9");
  static Color textGray = HexColor("9B9B9B");
  static Color lightGray = const Color.fromARGB(255, 214, 214, 214);
  static Color lightSeliver = HexColor("D9D9D9");
  static Color darkSeliver = HexColor("707070");

  // Dark
  static Color primaryDK = HexColor("EF3651");
  static Color bgDK = HexColor("1E1F28");
  static Color grayDK = HexColor("ABB4BD");
  static Color whiteDK = HexColor("F6F6F6");
  static Color darkSeliverDK = HexColor("707070");
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
