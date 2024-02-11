import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottom extends StatelessWidget {
  final String label;
  final Color textColor;
  final void Function()? onPressed;
  final Color? bg;
  final FontWeight? fontWeight;
  const CustomBottom({
    super.key,
    required this.label,
    this.textColor = Colors.white,
    this.onPressed,
    this.bg,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            shadowColor: AppColors.primary,
            elevation: 1,
            fixedSize: Size(338.sp, 50.sp),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide.none)),
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: fontWeight),
        ));
  }
}
