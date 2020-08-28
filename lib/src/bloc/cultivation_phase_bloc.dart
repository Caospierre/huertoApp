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
    if (idpublication != -1) {
      Observable(_repository.getUserCultivationPhase(idpublication))
          .pipe(cultivationPhaseController);
    }
  }

  void updatePhaseStatus(
      bool statePhase, DateTime notification, int idphase, int idnext) {
    this._repository.updatePhaseState(statePhase, notification, idphase);
    this._repository.updatePhaseStateNext(true, idnext);
  }

  void updatePublication(String phone, idpub, int iduser) {
    this._repository.updateUserPhone(iduser, phone);
    this._repository.updateActivePub(idpub);
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
