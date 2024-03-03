import 'package:flutter/material.dart';

const colors = [
  Color(0xffff6767),
  Color(0xff66e0da),
  Color(0xfff5a2d9),
  Color(0xfff0c722),
  Color(0xff6a85e5),
  Color(0xfffd9a6f),
  Color(0xff92db6e),
  Color(0xff73b8e5),
  Color(0xfffd7590),
  Color(0xffc78ae5),
   Color(0xffa8d582),
  Color(0xffe5989b),
  Color(0xffd1a1cb),
  Color(0xfffaaea9),
  Color(0xff8cd9b9),
  Color(0xffaacdbe),
  Color(0xffb3b3b3),
  Color(0xff8d6e63),
  Color(0xffd4ac6e),
  Color(0xffebcb8b),
];

Color getUserAvatarNameColor(String userId) {
  final index = userId.hashCode % colors.length;
  return colors[index];
}
