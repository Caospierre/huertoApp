import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:huerto_app/src/repository/app_repository.dart';

class HomeBloc extends BlocBase {
  final AppRepository _repository;

  HomeBloc(this._repository) {
    Observable(_repository.getPublications()).pipe(publicationsController);
    Observable(_repository.getUserPublications()).pipe(cultivationController);
    Observable(_repository.getTransaccion()).pipe(transaccionController);
  }
  Stream<List<PublicationModel>> getPubStream() {
    return _repository.getPublications();
  }

  Future<List<PublicationModel>> getPub() {
    return _repository.getPubs();
  }

  var controller = TextEditingController();
  var publicationsController = BehaviorSubject<List<PublicationModel>>();
  var cultivationController = BehaviorSubject<List<PublicationModel>>();
  var transaccionController = BehaviorSubject<List<PublicationModel>>();

  PublicationModel random() {
    var randomIndex = Random().nextInt(publicationsController.value.length);
    return publicationsController.value[randomIndex];
  }

  void sendPublication() {
    _repository.sendPublication(
      controller.text,
      1,
    );
    controller.clear();
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    controller.dispose();
    publicationsController.close();
    cultivationController.close();
    transaccionController.close();
    super.dispose();
  }
}
