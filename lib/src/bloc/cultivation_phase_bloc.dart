import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/models/user_cultivation_phase_model.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:rxdart/rxdart.dart';
import '../repository/cultivation_phase_repository.dart';

class CultivationPhaseBloc extends BlocBase {
  CultivationPhaseRepository _repository;

  CultivationPhaseBloc(int idpublication) {
    this._repository =
        GetIt.I<InitServices>().hasuraService.cultivationPhaseRepository;
    Observable(_repository.getUserCultivationPhase(idpublication))
        .pipe(cultivationPhaseController);
  }

  var controller = TextEditingController();
  var cultivationPhaseController =
      BehaviorSubject<List<UserCultivationPhaseModel>>();

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    controller.dispose();
    cultivationPhaseController.close();
    super.dispose();
  }
}
