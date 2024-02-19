import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/provider/auth/auth_cubit.dart';
import 'package:fashion_fusion/view/auth/screen/forget_password.dart';
import 'package:fashion_fusion/view/auth/screen/login_screen.dart';
import 'package:fashion_fusion/view/auth/screen/signup_screen.dart';
import 'package:fashion_fusion/view/navBar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Routes {
  static const String init = "/";
  static const String signup = "/signup";
  static const String forgetPassword = "/forgetPassword";
  static const String mainScren = "/mainScreen";
  static const String login = "/login";
}

class AppRoutes {
  static Route? onGenerate(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.init:
        return MaterialPageRoute(builder: (context) {
          return sl<SharedPreferences>().getBool("isLogin") == true
              ? const NavBar()
              : BlocProvider(
                  create: (context) => sl<AuthCubit>(),
                  child: const LoginScreen(),
                );
        });
      case Routes.signup:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => sl<AuthCubit>(),
                  child: const SignUpScreen(),
                ));
      case Routes.forgetPassword:
        return MaterialPageRoute(
            builder: (context) => const ForgetPasswordScreen());
      case Routes.mainScren:
        return MaterialPageRoute(builder: (context) => const NavBar());
      case Routes.login:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => sl<AuthCubit>(),
                  child: const LoginScreen(),
                ));
      default:
    }
    return null;
  }
}
