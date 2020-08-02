import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/cultivation_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/services/init_services.dart';

class CultivationModule {
  List<Bloc> get blocs => [
        Bloc((i) =>
            CultivationBloc(GetIt.I<InitServices>().hasuraService.cultivationRepository)),
      ];

  static Inject get to => Inject<CultivationModule>.of();
}
