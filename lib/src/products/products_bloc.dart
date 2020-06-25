import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/app_bloc.dart';
import 'package:huerto_app/src/app_module.dart';
import 'package:flutter/material.dart';

import '../app_repository.dart';

class ProductsBloc extends BlocBase {
  final AppRepository repository;
  final appBloc = AppModule.to.bloc<AppBloc>();

  var controllerEmail = TextEditingController();
  
  var controllerPassword = TextEditingController();

  ProductsBloc(this.repository);

  Future<bool> addproduct() async {
    try {
      print(controllerEmail.text);
      print(controllerPassword.text);
      var user = await repository.getUser(controllerEmail.text);
      appBloc.userController.add(user);
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<bool> startApp() async {
    try {
      var user = await repository.getUser(controllerEmail.text);
      appBloc.userController.add(user);
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }


  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }
}
