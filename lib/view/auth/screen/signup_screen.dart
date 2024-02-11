import 'package:fashion_fusion/config/routes/app_routes.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_images.dart';
import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/core/widgets/custom_button.dart';
import 'package:fashion_fusion/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(18.0).w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    "Sign up",
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600),
                  ),
                  50.verticalSpace,
                  // Name TextFiled
                  CustomTextFiled(
                    label: "Name",
                    hint: "John",
                    ctrl: _nameCtrl,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  15.verticalSpace,
                  // Email TextFiled
                  CustomTextFiled(
                    label: "Email",
                    hint: "abc@example.com",
                    ctrl: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  15.verticalSpace,
                  // Password TextFiled
                  CustomTextFiled(
                      label: "Password",
                      hint: "●●●●●●●●",
                      ctrl: _passwordCtrl,
                      isPassword: true),
                  10.verticalSpace,
                  // Already have an account Button
                  TextButton(
                      onPressed: () {
                        context.pushReplacementName(Routes.init);
                      },
                      child: Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      )),
                  25.verticalSpace,
                  // Login Button
                  CustomBottom(
                    onPressed: () {
                      // TODO: Login funciton
                    },
                    label: "SIGN UP",
                    bg: AppColors.primary,
                  ),
                  40.verticalSpace,
                  // Text:
                  const Center(
                      child: Text(
                    "Or login with social account",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                  10.verticalSpace,
                  // Login Using google & facebook
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialContainer(AppImages.googleLogo),
                      10.horizontalSpace,
                      _socialContainer(AppImages.facebokLogo),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Container _socialContainer(String imagePath) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20).w,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Image.asset(imagePath),
    );
  }
}
