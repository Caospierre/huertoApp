import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import 'package:huerto_app/src/module/index/app_module.dart';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/pages/home/home_page.dart';
import 'package:huerto_app/src/pages/started.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AppModule.to.bloc<AppBloc>();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: bloc.userController,
        builder: (context, snapshot) {
          return snapshot.hasData ? HomePage() : StartPage();
        },
      ),
    );
  }
}
