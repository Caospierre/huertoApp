import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/cultivation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../app_bloc.dart';
import '../service/cultivation_repository.dart';

class CultivationBloc extends BlocBase {
  final CultivationRepository _repository;
  final AppBloc appBloc;

  CultivationBloc(this._repository, this.appBloc) {
    Observable(_repository.getCultivo()).pipe(cultivoController);
  }

  var controller = TextEditingController();
  var cultivoController = BehaviorSubject<List<CultivationModel>>();

  CultivationModel random() {
    var randomIndex = Random().nextInt(cultivoController.value.length);
    return cultivoController.value[randomIndex];
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
    cultivoController.close();
    super.dispose();
  }
}

