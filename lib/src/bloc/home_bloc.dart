import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import 'package:huerto_app/src/repository/app_repository.dart';

class HomeBloc extends BlocBase {
  final AppRepository _repository;
  final AppBloc appBloc;

  HomeBloc(this._repository, this.appBloc) {
    Observable(_repository.getPublications()).pipe(publicationsController);
  }

  var controller = TextEditingController();
  var publicationsController = BehaviorSubject<List<publicationModel>>();

  publicationModel random() {
    var randomIndex = Random().nextInt(publicationsController.value.length);
    return publicationsController.value[randomIndex];
  }

  void sendPublication() {
    _repository.sendPublication(
      controller.text,
      appBloc.userController.value.id,
    );
    controller.clear();
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    controller.dispose();
    publicationsController.close();
    super.dispose();
  }
}
