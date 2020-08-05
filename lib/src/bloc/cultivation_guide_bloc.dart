import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/cultivation_guide_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import '../repository/cultivation_guide_repository.dart';

class CultivationGuideBloc extends BlocBase {
  final CultivationGuideRepository _repository;
  final AppBloc appBloc;

  CultivationGuideBloc(this._repository, this.appBloc) {
    Observable(_repository.getCultivationGuide())
        .pipe(cultivationGuideController);
  }

  var controller = TextEditingController();
  var cultivationGuideController =
      BehaviorSubject<List<CultivationGuideModel>>();

  CultivationGuideModel random() {
    var randomIndex = Random().nextInt(cultivationGuideController.value.length);
    return cultivationGuideController.value[randomIndex];
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
    cultivationGuideController.close();
    super.dispose();
  }
}
