import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import 'package:huerto_app/src/module/index/app_module.dart';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/repository/app_repository.dart';

class LoginBloc extends BlocBase {
  final AppRepository repository;
  final appBloc = AppBloc();

  var controllerEmail = TextEditingController();

  var controllerPassword = TextEditingController();

  LoginBloc(this.repository);

  Future<bool> login() async {
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

  Future<bool> createUser(String email) async {
    try {
      print(controllerEmail.text);
      print(controllerPassword.text);
      var user = await repository.createUser(email);
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
