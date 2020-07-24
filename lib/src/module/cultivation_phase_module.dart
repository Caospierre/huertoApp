import 'package:huerto_app/src/module/index/app_module.dart';
import 'package:huerto_app/src/bloc/cultivation_phase_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/pages/cultivation_phase/cultivation_phase_page.dart';

import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import '../repository/cultivation_phase_repository.dart';

class CultivoPhaseModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc(
          (i) => CultivationPhaseBloc(
            AppModule.to.get<CultivationPhaseRepository>(),
            AppModule.to.bloc<AppBloc>(),
          ),
        ),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => CultivationPhasePage();

  static Inject get to => Inject<CultivoPhaseModule>.of();
}