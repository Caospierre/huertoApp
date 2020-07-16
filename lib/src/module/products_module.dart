import 'package:huerto_app/src/module/index/app_module.dart';
import 'package:huerto_app/src/bloc/products_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:huerto_app/src/repository/app_repository.dart';

class ProductsModule {
  List<Bloc> get blocs => [
        Bloc((i) => ProductsBloc(AppModule.to.get<AppRepository>())),
      ];

  List<Dependency> get dependencies => [];

  static Inject get to => Inject<ProductsModule>.of();
}
