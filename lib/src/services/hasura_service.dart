import 'package:huerto_app/src/bloc/login_bloc.dart';
import 'package:huerto_app/src/repository/app_repository.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/utils/api_info.dart';

class HasuraService {
  AppRepository _appRepository;

  HasuraService() {
    this._appRepository = new AppRepository(HasuraConnect(HasuraBackendAPI));
  }

  AppRepository get appRepository => _appRepository;
}
