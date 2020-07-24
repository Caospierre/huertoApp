import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:huerto_app/src/repository/publication_repository.dart';

class PublicationBloc extends BlocBase {
  final PublicationRepository _repository;

  PublicationBloc(this._repository) {}

  Future<PublicationModel> getPublications(int id) {
    return _repository.getPublications(id);
  }

  var controller = TextEditingController();
  var publicationsController = BehaviorSubject<List<PublicationModel>>();

  void sendPublication() {
    /* _repository.sendPublication(
      controller.text,
      1,
    );
    controller.clear();*/
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    controller.dispose();
    publicationsController.close();
    super.dispose();
  }
}
