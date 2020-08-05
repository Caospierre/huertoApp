import 'package:huerto_app/src/repository/app_repository.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/src/repository/cultivation_repository.dart';
import 'package:huerto_app/src/repository/publication_repository.dart';
import 'package:huerto_app/utils/api_info.dart';

class HasuraService {
  AppRepository _appRepository;
  PublicationRepository _publicationRepository;
  CultivationRepository _cultivationRepository;
  HasuraConnect _hasuraConect;
  HasuraService() {
    this._hasuraConect = HasuraConnect(HasuraBackendAPI);
    print(HasuraBackendAPI);
    this._appRepository = new AppRepository();
    this._publicationRepository = PublicationRepository();
    this._cultivationRepository = CultivationRepository();
  }

  AppRepository get appRepository => _appRepository;
  HasuraConnect get hasuraConect => _hasuraConect;
  PublicationRepository get publicationRepository => _publicationRepository;
  CultivationRepository get cultivationRepository => _cultivationRepository;
}
