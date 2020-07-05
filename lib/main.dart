import 'package:huerto_app/src/pages/login/SignIn.dart';
import 'package:huerto_app/src/pages/login//SignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huerto_app/src/pages/home_page.dart';
import 'package:huerto_app/src/module/home_module.dart';
import 'package:huerto_app/src/pages/started.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Cosecha',
      theme: ThemeData(),
      home: HomePage(),
      routes: {
        '/home': (BuildContext context) => HomePage(),
        '/signin': (BuildContext context) => SignIn(),
        '/signup': (BuildContext context) => SignUp(),
      },
    );
  }
}
