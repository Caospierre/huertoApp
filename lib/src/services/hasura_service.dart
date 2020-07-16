import 'package:huerto_app/src/repository/app_repository.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/utils/api_info.dart';

class HasuraService {
  AppRepository _appRepository;

  HasuraService() {
    this._appRepository = new AppRepository(HasuraConnect(HasuraBackendAPI));
  }

  AppRepository get appRepository => _appRepository;
}
