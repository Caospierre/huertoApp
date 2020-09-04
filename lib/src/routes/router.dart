import 'package:flutter/material.dart';
import 'package:huerto_app/src/pages/login/TestPage.dart';
import 'package:huerto_app/src/pages/cultivation/add_cultivation_page.dart';

import 'package:huerto_app/src/pages/home/publication_details.dart';
import 'package:huerto_app/src/pages/home/home_page.dart';
import 'package:huerto_app/src/pages/login/SignIn.dart';
import 'package:huerto_app/src/pages/login//SignUp.dart';
import 'package:huerto_app/src/pages/phase/onphase_screen.dart';
import 'package:huerto_app/src/pages/started.dart';
import 'package:huerto_app/src/pages/error_page.dart';

class NavigatorToPath {
  static const String Home = '/home';
  static const String SignUP = '/signup';
  static const String SignIn = '/signin';
  static const String Started = '/start';
  static const String App = '/app';
  static const String Publication = '/food_details';
  static const String Test = '/test';
  static const String Error = 'error';
  static const String AddCultivation = '/add_cultivation';
  static const String PhaseDetail = '/phase_detail';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case NavigatorToPath.Started:
      return MaterialPageRoute(builder: (_) => StartPage());
    case NavigatorToPath.Home:
      return MaterialPageRoute(builder: (_) => HomePage());
    case NavigatorToPath.SignUP:
      return MaterialPageRoute(builder: (_) => SignUp());
    case NavigatorToPath.SignIn:
      return MaterialPageRoute(builder: (_) => SignIn());
    case NavigatorToPath.Error:
      return MaterialPageRoute(builder: (_) => ErrorPage());
    case NavigatorToPath.Test:
      return MaterialPageRoute(
          builder: (_) => TestPage(idUser: settings.arguments));
    case NavigatorToPath.AddCultivation:
      return MaterialPageRoute(
          builder: (_) => AddCultivationPage(settings.arguments));
    case NavigatorToPath.Publication:
      return MaterialPageRoute(
          builder: (_) =>
              PublicationDetailsPage(publication: settings.arguments));
      break;
    case NavigatorToPath.PhaseDetail:
      return MaterialPageRoute(
          builder: (_) => OnPhaseScreen(listPhase: settings.arguments));
      break;
    default:
      return MaterialPageRoute(builder: (_) => HomePage());
  }
}
