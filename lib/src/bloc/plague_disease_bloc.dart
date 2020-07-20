import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/plague_disease_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import '../repository/plague_disease_repository.dart';

class PlagueDiseaseBloc extends BlocBase {
  final PlagueDiseaseRepository _repository;
  final AppBloc appBloc;

  PlagueDiseaseBloc(this._repository, this.appBloc) {
    Observable(_repository.getPlagueDisease()).pipe(plagueDiseaseController);
  }

  var controller = TextEditingController();
  var plagueDiseaseController = BehaviorSubject<List<Plague_DiseaseModel>>();

  Plague_DiseaseModel random() {
    var randomIndex = Random().nextInt(plagueDiseaseController.value.length);
    return plagueDiseaseController.value[randomIndex];
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
    plagueDiseaseController.close();
    super.dispose();
  }
}
