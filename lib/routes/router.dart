import 'package:flutter/material.dart';
import 'package:huerto_app/src/pages/publication_details.dart';
import 'package:huerto_app/src/pages/home/home_page.dart';
import 'package:huerto_app/src/pages/login/SignIn.dart';
import 'package:huerto_app/src/pages/login//SignUp.dart';

const String homeViewRoute = '/home';
const String SignupViewRoute = '/signup';
const String SigninViewRoute = '/signin';
const String publicationDetailsViewRoute = '/food_details';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homeViewRoute:
      return MaterialPageRoute(builder: (_) => HomePage());
    case SignupViewRoute:
      return MaterialPageRoute(builder: (_) => SignUp());
    case SigninViewRoute:
      return MaterialPageRoute(builder: (_) => SignIn());
    case publicationDetailsViewRoute:
      return MaterialPageRoute(
          builder: (_) =>
              PublicationDetailsPage(publicationId: settings.arguments));

      break;
    default:
      return MaterialPageRoute(builder: (_) => HomePage());
  }
}
