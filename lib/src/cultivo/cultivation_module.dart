import 'package:huerto_app/src/app_module.dart';
import 'package:huerto_app/src/cultivo/cultivation_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/cultivo/cultivation_page.dart';

import '../app_bloc.dart';
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
  Widget get view => CultivoPage();

  static Inject get to => Inject<CultivoModule>.of();
}
