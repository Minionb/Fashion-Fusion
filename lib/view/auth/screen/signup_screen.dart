import 'package:fashion_fusion/config/routes/app_routes.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_images.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/utils/helper_validation.dart';
import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/core/widgets/custom_button.dart';
import 'package:fashion_fusion/core/widgets/custom_text_field.dart';
import 'package:fashion_fusion/data/auth/model/signup_model.dart';
import 'package:fashion_fusion/provider/auth/auth_cubit.dart';
import 'package:fashion_fusion/provider/states/cubit_states.dart';
import 'package:fashion_fusion/view/auth/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:phone_form_field/phone_form_field.dart';

import 'package:toastification/toastification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return HelperMethod.loader(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 50).w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      "Sign up",
                      style: TextStyle(
                          fontSize: 30.sp, fontWeight: FontWeight.w600),
                    ),
                    50.verticalSpace,
                    // Email TextFiled
                    CustomTextFiled(
                      validator: (p0) => ValidationHelper.emailValidation(p0),
                      label: "Email",
                      hint: "abc@example.com",
                      ctrl: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    15.verticalSpace,
                    // Name TextFiled
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFiled(
                            validator: (p0) =>
                                ValidationHelper.firstNameValidation(p0),
                            label: "First Name",
                            hint: "John",
                            ctrl: _firstNameCtrl,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: CustomTextFiled(
                            validator: (p0) =>
                                ValidationHelper.secondNameValidation(p0),
                            label: "Last Name",
                            hint: "Smith",
                            ctrl: _lastNameCtrl,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    15.verticalSpace,
                    _phoneNumber(),
                    15.verticalSpace,
                    CustomTextFiled(
                      validator: (p0) => ValidationHelper.addressValidation(p0),
                      label: "Address",
                      hint: "Tea Garden Circle",
                      ctrl: _addressCtrl,
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    15.verticalSpace,

                    // Password TextFiled
                    CustomTextFiled(
                        validator: (p0) =>
                            ValidationHelper.passwordValidation(p0),
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
                    BlocListener<AuthCubit, CubitState>(
                      listener: (context, state) {
                        if (state is DataLoading) {
                          context.loaderOverlay.show();
                        }
                        if (state is DataSuccess) {
                          context.loaderOverlay.hide();
                          HelperMethod.showToast(context,
                              title: const Text("Thank you!"),
                              description: const Text(
                                  "Thanks for signing up. Welcome to our application. We are happy to have you on board."),
                              type: ToastificationType.success);
                          Future.delayed(const Duration(seconds: 2), () {
                            context.pushReplacementName(Routes.init);
                          });
                        }
                        if (state is DataFailure) {
                          context.loaderOverlay.hide();
                          HelperMethod.showToast(context,
                              title: Text(state.errorMessage),
                              type: ToastificationType.error);
                        }
                      },
                      child: CustomBottom(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().register(
                                  RegisterUserModel(
                                      telephoneNumber: _phoneCtrl.text,
                                      email: _emailCtrl.text,
                                      password: _passwordCtrl.text,
                                      firstName: _firstNameCtrl.text,
                                      lastName: _lastNameCtrl.text,
                                      address: _addressCtrl.text,
                                      dateOfBirth: "1990-01-01",
                                      gender: Gender.male),
                                );

                            showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Successfully registered account!'),
                                      content: Text('Enjoy shopping!'),
                                    );
                                  },
                                );
                          }
                        },
                        label: "SIGN UP",
                        bg: AppColors.primary,
                      ),
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
      ),
    );
  }

  Column _phoneNumber() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Phone Number",
              style: TextStyle(
                color: AppColors.textGray,
                fontSize: 14,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
        ),
        8.verticalSpace,
        PhoneFormField(
          validator: (p0) => ValidationHelper.phoneNumberValidation(p0?.nsn),
          onChanged: (p0) => setState(() => _phoneCtrl.text = p0.international),
          isCountrySelectionEnabled: false,
          initialValue: const PhoneNumber(isoCode: IsoCode.CA, nsn: ""),
          showFlagInInput: true,
          decoration: InputDecoration(
            hintText: "6472420891",
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10).r,
                borderSide: BorderSide.none),
          ),
          countrySelectorNavigator:
              const CountrySelectorNavigator.bottomSheet(),
          autofillHints: const [AutofillHints.telephoneNumber],
        ),
      ],
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
