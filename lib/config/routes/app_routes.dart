import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/provider/auth/auth_cubit.dart';
import 'package:fashion_fusion/provider/customerCubit/customer/customer_cubit.dart';
import 'package:fashion_fusion/view/admin/view/adminNavBar/screen/admin_navbar.dart';
import 'package:fashion_fusion/view/auth/screen/forget_password.dart';
import 'package:fashion_fusion/view/auth/screen/login_screen.dart';
import 'package:fashion_fusion/view/auth/screen/signup_screen.dart';
import 'package:fashion_fusion/view/auth/screen/welcome_screen.dart';
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
  static const String adminMainScreen = "/adminMainScreen";
}

class AppRoutes {
  static get customerQueryParams => null;

  static Route? onGenerate(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.init:
        return MaterialPageRoute(builder: (context) {
          // TODO
          // return const WelcomePage();
          return sl<SharedPreferences>().getBool("isLogin") == true
              ? ((sl<SharedPreferences>().getString("userType") == "customer")
                  ? const NavBar()
                  // To check if the user is admin or customer
                  : BlocProvider(
                      create: (context) => sl<CustomerCubit>()..getCustomer(customerQueryParams),
                      child: const AdminNavBar(),
                    ))
              : BlocProvider(
                  create: (context) => sl<AuthCubit>(),
                  child: const WelcomePage(),
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
            builder: (context) => BlocProvider(
              create: (contex) => sl<AuthCubit>(),
              child: const ForgetPasswordScreen(),
              ));
      case Routes.mainScren:
        return MaterialPageRoute(builder: (context) => const NavBar());
      case Routes.login:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => sl<AuthCubit>(),
                  child: const LoginScreen(),
                ));
      case Routes.adminMainScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => sl<CustomerCubit>()..getCustomer(customerQueryParams),
                  child: const AdminNavBar(),
                ));
      default:
    }
    return null;
  }
}
