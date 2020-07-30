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

  var txtPubcontroller = TextEditingController();

  var txtUsercontroller = TextEditingController();
  var publicationsController = BehaviorSubject<List<PublicationModel>>();
  void checkPublication() {
    this._repository.checkedPublication(int.parse(this.txtPubcontroller.text),
        int.parse(this.txtUsercontroller.text));
  }

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
    txtPubcontroller.dispose();
    txtUsercontroller.dispose();
    publicationsController.close();
    super.dispose();
  }
}
