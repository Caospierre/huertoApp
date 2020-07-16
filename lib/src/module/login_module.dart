import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/login_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/services/init_services.dart';

class LoginModule {
  List<Bloc> get blocs => [
        Bloc((i) =>
            LoginBloc(GetIt.I<InitServices>().hasuraService.appRepository)),
      ];

  static Inject get to => Inject<LoginModule>.of();
}
