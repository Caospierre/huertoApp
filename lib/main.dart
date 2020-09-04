import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huerto_app/src/pages/login/SignIn.dart';
import 'package:huerto_app/src/routes/router.dart' as router;
import 'package:huerto_app/src/services/init_services.dart';
import 'package:get_it/get_it.dart';
//import 'package:huerto_app/src/module/home_module.dart';
//import 'package:huerto_app/src/pages/started.dart';

void main() async {
  final services = await InitServices.initialize();
  _setupLocator(services);
  runApp(ServicesProvider(services: services, child: MyApp()));
}

void _setupLocator(InitServices poolServices) {
  GetIt.instance.registerSingleton(poolServices);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      //  debugShowCheckedModeBanner: false,
      title: 'Mi Cosecha',
      theme: ThemeData(primaryColor: Color(0xFF5B16D0)),
      home: SignIn(),
      //initialRoute: router.NavigatorToPath.SignIn,
      onGenerateRoute: router.generateRoute,
    );
  }
}
