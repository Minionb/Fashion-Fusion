import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    super.key,
    required this.buttonName,
    required this.onTap,
    required this.bgColor,
    required this.textColor,
  });
  final String buttonName;
  final Function onTap;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.sp,
      width: double.infinity,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10).r,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(-1, 1))
          ]),
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith(
            (states) => Colors.black12,
          ),
        ),
        onPressed: () {
          onTap();
        },
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: 14.sp,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
