import 'package:flutter/material.dart';

class NavigatorToPath {
  static const String Home = '/home';
  static const String SignUP = '/signup';
  static const String SignIn = '/signin';
  static const String Other = 'audio/Pase4.mp3';
}

class NavigatorService {
  NavigatorService() {}

  void navigateToUrl(BuildContext context, String path) {
    Navigator.pushReplacementNamed(context, path);
    print("Navigacion Url:" + path);
  }

  void navigateToHome(BuildContext context) {
    navigateToUrl(context, NavigatorToPath.Home);
  }
}
