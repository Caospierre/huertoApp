import 'package:huerto_app/src/repository/app_repository.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/bloc/index/app_bloc.dart';

class AppModule {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => AppBloc()),
      ];

  static Inject get to => Inject<AppModule>.of();
}
