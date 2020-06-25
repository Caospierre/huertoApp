import 'package:huerto_app/src/app_module.dart';
import 'package:huerto_app/src/products/products_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/products/products_page.dart';

import '../app_repository.dart';

class ProductsModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ProductsBloc(AppModule.to.get<AppRepository>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => ProductsPage();

  static Inject get to => Inject<ProductsModule>.of();
}
