import 'package:fashion_fusion/view/auth/screen/login_screen.dart';
import 'package:fashion_fusion/view/auth/screen/signup_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String init = "/";
  static const String signup = "/signup";
}

class AppRoutes {
  static Route? onGenerate(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.init:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case Routes.signup:
        return MaterialPageRoute(builder: (context) => const SignUpScreen());
      default:
    }
    return null;
  }
}
