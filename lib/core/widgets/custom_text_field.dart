import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFiled extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController ctrl;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onFieldSubmitted;
  final bool isPassword;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  const CustomTextFiled({
    super.key,
    required this.label,
    required this.hint,
    required this.ctrl,
    this.validator,
    this.keyboardType,
    this.onFieldSubmitted,
    this.isPassword = false,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _label(),
        8.verticalSpace,
        TextFormField(
          onChanged: widget.onChanged,
          obscureText: widget.isPassword && !showPassword,
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          controller: widget.ctrl,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() => showPassword = !showPassword);
                    },
                    icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility))
                : const SizedBox(),
            hintText: widget.hint,
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10).r,
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Row _label() {
    return Row(
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: AppColors.textGray,
            fontSize: 14,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ],
    );
  }
}
