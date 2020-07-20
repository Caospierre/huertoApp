import 'package:huerto_app/src/module/index/app_module.dart';
import 'package:huerto_app/src/bloc/cultivation_guide_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/pages/cultivation_guide/cultivation_guide_page.dart';

import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import '../repository/cultivation_guide_repository.dart';

class CultivoGuideModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc(
          (i) => CultivationGuideBloc(
            AppModule.to.get<CultivationGuideRepository>(),
            AppModule.to.bloc<AppBloc>(),
          ),
        ),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => CultivationGuidePage();

  static Inject get to => Inject<CultivoGuideModule>.of();
}