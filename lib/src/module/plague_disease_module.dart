import 'package:huerto_app/src/models/plague_disease_model.dart';
import 'package:huerto_app/src/module/index/app_module.dart';
import 'package:huerto_app/src/bloc/plague_disease_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/pages/plague_disease/plague_disease_page.dart';

import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import '../repository/plague_disease_repository.dart';

class PlagueDiseaseModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc(
          (i) => PlagueDiseaseBloc(
            AppModule.to.get<PlagueDiseaseRepository>(),
            AppModule.to.bloc<AppBloc>(),
          ),
        ),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => PlagueDiseasePage();

  static Inject get to => Inject<PlagueDiseaseModule>.of();
}
