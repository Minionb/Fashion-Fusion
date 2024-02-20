import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/navigator_extension.dart';
import 'package:fashion_fusion/core/widgets/text_button.dart';
import 'package:fashion_fusion/provider/auth/auth_cubit.dart';
import 'package:fashion_fusion/view/auth/screen/login_screen.dart';
import 'package:fashion_fusion/view/auth/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Flexible(
                child: Column(
                  children: [
                    Lottie.asset('assets/images/welcome.json'),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Fashion Fusion\nWomen's Clothing ",
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    10.verticalSpace,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Fashion Fusion is your ultimate destination for women's clothing shopping in the Greater Toronto Area (GTA). Browse through our curated selections of Tops, Bottoms, Dresses, Hoodies & Sweats, and Accessories, carefully chosen to meet the diverse preferences of our clientele.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              Card(
                child: Container(
                  height: 50.sp,
                  decoration: BoxDecoration(
                    color: AppColors.darkSeliver,
                    borderRadius: BorderRadius.circular(18).r,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyTextButton(
                          bgColor: Colors.white,
                          buttonName: 'Register',
                          onTap: () {
                            context.push(BlocProvider(
                              create: (context) => sl<AuthCubit>(),
                              child: const SignUpScreen(),
                            ));
                          },
                          textColor: Colors.black87,
                        ),
                      ),
                      Expanded(
                        child: MyTextButton(
                          bgColor: AppColors.darkSeliver,
                          buttonName: 'Sign In',
                          onTap: () {
                            context.push(BlocProvider(
                              create: (context) => sl<AuthCubit>(),
                              child: const LoginScreen(),
                            ));
                          },
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              5.verticalSpace,
              TextButton(
                  onPressed: () {
                    context.push(BlocProvider(
                      create: (context) => sl<AuthCubit>(),
                      child: const LoginScreen(
                        isAdmin: true,
                      ),
                    ));
                  },
                  child: Text(
                    "Login as Admin",
                    style: TextStyle(
                        color: AppColors.darkSeliver, fontSize: 13.sp),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
