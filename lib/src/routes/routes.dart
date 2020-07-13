import 'package:flutter/material.dart';
import 'package:huerto_app/src/home/home_page.dart';
import 'package:huerto_app/src/login/started.dart';
import 'package:huerto_app/src/pages/error_page.dart';


Map<String,WidgetBuilder> getApplicationRoutes(){
  return <String, WidgetBuilder>{
    'start'  : (BuildContext context) => StartPage(),
    '/'      : (BuildContext context) => HomePage(),
    'error'  : (BuildContext context) => ErrorPage(),
  };
}
