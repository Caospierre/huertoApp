import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/cultivation_phase_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import '../repository/cultivation_phase_repository.dart';

class CultivationPhaseBloc extends BlocBase {
  final CultivationPhaseRepository _repository;
  final AppBloc appBloc;

  CultivationPhaseBloc(this._repository, this.appBloc) {
    Observable(_repository.getCultivationPhase()).pipe(cultivationPhaseController);
  }

  var controller = TextEditingController();
  var cultivationPhaseController = BehaviorSubject<List<Cultivation_PhaseModel>>();

  Cultivation_PhaseModel random() {
    var randomIndex = Random().nextInt(cultivationPhaseController.value.length);
    return cultivationPhaseController.value[randomIndex];
  }

  //void sendPublication() {
    //_repository.sendPublication(
      //controller.text,
      //appBloc.userController.value.id,
    //);
    //controller.clear();
  //}

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    controller.dispose();
    cultivationPhaseController.close();
    super.dispose();
  }
}
