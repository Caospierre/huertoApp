import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import 'package:huerto_app/src/models/cultivation_model.dart';
import 'package:flutter/cupertino.dart';

import '../repository/cultivation_repository.dart';

class CultivationBloc extends BlocBase {
  final CultivationRepository _repository;
  //final appBloc = AppBloc();
  var _cultivation;

  var controllerName = TextEditingController();
  var controllerDescription = TextEditingController();

  CultivationBloc(this._repository);

  CultivationModel get cultivation => _cultivation;

  Future<bool> createCultivation(int userId, int idCultivo) async {
    try {
      print(controllerName.text);
      print(controllerDescription.text);
      var cultivation = await _repository.createCultivation(
          controllerName.text, controllerDescription.text, 1, userId);
      print("cultivo:" + cultivation.description.toString());
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    controllerName.dispose();
    controllerDescription.dispose();
    super.dispose();
  }
}
