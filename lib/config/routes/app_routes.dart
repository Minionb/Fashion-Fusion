import 'package:flutter/material.dart';

class Routes {
  static const String init = "/";
}

class AppRoutes {
  static Route? onGenerate(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.init:
        return MaterialPageRoute(builder: (context) => Container());
      default:
    }
    return null;
  }
}
