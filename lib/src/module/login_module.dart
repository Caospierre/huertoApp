import 'package:huerto_app/src/module/index/app_module.dart';
import 'package:huerto_app/src/bloc/login_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/pages/login/SignIn.dart';

import 'package:huerto_app/src/repository/app_repository.dart';

class LoginModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => LoginBloc(AppModule.to.get<AppRepository>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => SignIn();

  static Inject get to => Inject<LoginModule>.of();
}
