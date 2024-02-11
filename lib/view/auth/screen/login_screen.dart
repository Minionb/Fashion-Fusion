import 'package:fashion_fusion/config/routes/app_routes.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_images.dart';
import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/core/widgets/custom_button.dart';
import 'package:fashion_fusion/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

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
                    "Login",
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600),
                  ),
                  50.verticalSpace,
                  // Email TextFiled
                  CustomTextFiled(
                    label: "Email",
                    hint: "abc@example.com",
                    ctrl: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  15.verticalSpace,
                  // Pasword TextFiled
                  CustomTextFiled(
                      label: "Password",
                      hint: "●●●●●●●●",
                      ctrl: _passwordCtrl,
                      isPassword: true),
                  10.verticalSpace,
                  // forget Password Button
                  TextButton(
                      onPressed: () {
                        context.pushNamed(Routes.forgetPassword);
                      },
                      child: Text(
                        "Forget Your Password?",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      )),
                  25.verticalSpace,
                  // Login Button
                  CustomBottom(
                    onPressed: () {
                      //TODO: Login Funciton
                    },
                    label: "LOGIN",
                    bg: AppColors.primary,
                  ),
                  40.verticalSpace,
                  // Text
                  const Center(
                      child: Text(
                    "Or login with social account",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                  10.verticalSpace,
                  // Login with facebook & google
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialContainer(AppImages.googleLogo),
                      10.horizontalSpace,
                      _socialContainer(AppImages.facebokLogo),
                    ],
                  ),
                  10.verticalSpace,
                  // Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      // To Go to sing up screen
                      TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {
                            // push and replacment screen that the user can't come back form previous screeen
                            context.pushReplacementName(Routes.signup);
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: AppColors.primary),
                          ))
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
