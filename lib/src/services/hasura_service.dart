import 'package:huerto_app/src/repository/app_repository.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/utils/api_info.dart';

class HasuraService {
  HasuraService();

  List<Dependency> get dependencies => [
        Dependency((i) => AppRepository(i.get<HasuraConnect>())),
        Dependency((i) => HasuraConnect(HasuraBackendAPI)),
      ];
}
