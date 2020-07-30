import 'package:flutter/material.dart';
import 'package:huerto_app/src/routes/router.dart';

class NavigatorService {
  NavigatorService() {}

  void navigateToUrl(BuildContext context, String path) {
    Navigator.pushReplacementNamed(context, path);
    print("Navigacion Url:" + path);
  }

  void navigateToHome(BuildContext context, String urlPath) {
    navigateToUrl(context, NavigatorToPath.Home);
  }
}
