import 'package:fashion_fusion/config/routes/app_routes.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/core/widgets/custom_button.dart';
import 'package:fashion_fusion/core/widgets/custom_text_field.dart';
import 'package:fashion_fusion/provider/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

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
                    "Forget Password",
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600),
                  ),
                  50.verticalSpace,
                  const Text(
                      "Please, enter your email address. You will receive a link to create a new password via email."),
                  20.verticalSpace,
                  // Email TextFiled
                  CustomTextField(
                    label: "Email",
                    hint: "abc@example.com",
                    ctrl: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),

                  25.verticalSpace,
                  // Login Button
                  CustomButton(
                    onPressed: onSendButtonPressed,
                    label: "SEND",
                    bg: AppColors.primary,
                  ),
                  40.verticalSpace,

                  // To Go to sing up screen
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

  void onSendButtonPressed() {
    context.read<AuthCubit>().resetPassword(_emailCtrl.text);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Reset password request sent!'),
          content: const Text('Reset password token will be sent to your email.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.pushReplacementName(Routes.login);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
