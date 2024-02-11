import 'package:flutter/material.dart';


extension ExtendNavigator on BuildContext {
  Future<dynamic> push(Widget page) async {
    Navigator.push(this, MaterialPageRoute(builder: (_) => page));
  }

  Future<dynamic> pushNamed(String name) async {
    Navigator.pushNamed(this, name);
  }

  // Future<dynamic> pushNamedNAV(Widget page, {bool withNav = false}) async {
  //   return await pushNewScreen(
  //     this,
  //     screen: page,
  //     withNavBar: withNav,
  //     pageTransitionAnimation: PageTransitionAnimation.cupertino,
  //   );
  // }

  Future<dynamic> pushReplacement(Widget page) async {
    Navigator.pushReplacement(this, MaterialPageRoute(builder: (_) => page));
  }

  Future<dynamic> pop([result]) async {
    Navigator.pop(this);
  }

  Future<dynamic> pushReplacementName(String name) async {
    Navigator.pushReplacementNamed(this, name);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String name) async {
    Navigator.pushNamedAndRemoveUntil(this, name, (route) => false);
  }
}