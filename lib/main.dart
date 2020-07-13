
//import 'package:component/src/pages/home_temp.dart';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/pages/error_page.dart';
import 'package:huerto_app/src/routes/routes.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Component App',
      //home: HomePage()
      initialRoute: 'start',
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          builder: (BuildContext context) =>ErrorPage()
        );
      },
    );
  }
}