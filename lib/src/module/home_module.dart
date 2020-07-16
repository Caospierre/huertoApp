import 'package:huerto_app/src/module/index/app_module.dart';
import 'package:huerto_app/src/bloc/home_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/pages/home/home_page.dart';
import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import 'package:huerto_app/src/repository/app_repository.dart';

class HomeModule {
  List<Bloc> get blocs => [
        Bloc(
          (i) => HomeBloc(
            AppModule.to.get<AppRepository>(),
            AppModule.to.bloc<AppBloc>(),
          ),
        ),
      ];

  List<Dependency> get dependencies => [];

  static Inject get to => Inject<HomeModule>.of();
}
