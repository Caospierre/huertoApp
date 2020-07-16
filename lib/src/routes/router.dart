import 'package:flutter/material.dart';
import 'package:huerto_app/src/module/home_module.dart';
import 'package:huerto_app/src/module/index/app_module.dart';
import 'package:huerto_app/src/module/login_module.dart';
import 'package:huerto_app/src/pages/publication_details.dart';
import 'package:huerto_app/src/pages/home/home_page.dart';
import 'package:huerto_app/src/pages/login/SignIn.dart';
import 'package:huerto_app/src/pages/login//SignUp.dart';
import 'package:huerto_app/src/pages/started.dart';

class NavigatorToPath {
  static const String Home = '/home';
  static const String SignUP = '/signup';
  static const String SignIn = '/signin';
  static const String Started = '/start';
  static const String App = '/app';
  static const String Publication = '/food_details';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case NavigatorToPath.Started:
      return MaterialPageRoute(builder: (_) => Started());
    case NavigatorToPath.Home:
      return MaterialPageRoute(builder: (_) => HomeModule());
    case NavigatorToPath.SignUP:
      return MaterialPageRoute(builder: (_) => SignUp());
    case NavigatorToPath.SignIn:
      return MaterialPageRoute(builder: (_) => LoginModule());

    case NavigatorToPath.App:
      return MaterialPageRoute(builder: (_) => AppModule());
    case NavigatorToPath.Publication:
      return MaterialPageRoute(
          builder: (_) =>
              PublicationDetailsPage(publicationId: settings.arguments));

      break;
    default:
      return MaterialPageRoute(builder: (_) => HomePage());
  }
}
