import 'package:fashion_fusion/view/auth/screen/login_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String init = "/";
}

class AppRoutes {
  static Route? onGenerate(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.init:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      default:
    }
    return null;
  }
}
