import 'package:huerto_app/src/module/index/app_module.dart';
import 'package:huerto_app/src/bloc/cultivation_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';


import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import 'package:huerto_app/src/pages/cultivation/add_cultivation_page.dart';
import '../repository/cultivation_repository.dart';

class CultivoModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc(
          (i) => CultivationBloc(
            AppModule.to.get<CultivationRepository>(),
            AppModule.to.bloc<AppBloc>(),
          ),
        ),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => AddCultivationPage();

  static Inject get to => Inject<CultivoModule>.of();
}
