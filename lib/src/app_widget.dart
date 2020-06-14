import 'package:huerto_app/src/app_bloc.dart';
import 'package:huerto_app/src/app_module.dart';
import 'package:huerto_app/src/home/home_module.dart';
import 'package:flutter/material.dart';

import 'login/login_module.dart';

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
          return snapshot.hasData ? HomeModule() : LoginModule();
        },
      ),
    );
  }
}
