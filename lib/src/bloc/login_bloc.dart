import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/index/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/models/user_model.dart';
import 'package:huerto_app/src/repository/app_repository.dart';
import 'package:huerto_app/src/services/init_services.dart';

class LoginBloc extends BlocBase {
  final AppRepository repository;
  final appBloc = AppBloc();
  UserModel _user;
  var controllerEmail = TextEditingController();

  var controllerPassword = TextEditingController();

  LoginBloc(this.repository);

  UserModel get user => _user;

  Future<bool> login() async {
    try {
      var user = await repository.getUser(controllerEmail.text);
      GetIt.I<InitServices>().authService.userLogin = user;
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<bool> createUser(String email) async {
    try {
      var user = await repository.createUser(email);
      GetIt.I<InitServices>().authService.userLogin = user;
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<UserModel> isUser(String email) async {
    try {
      this._user = await repository.getUser(email);
      GetIt.I<InitServices>().authService.userLogin = this._user;

      return this._user;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<bool> startApp() async {
    try {
      var user = await repository.getUser(controllerEmail.text);
      GetIt.I<InitServices>().authService.userLogin = user;
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
