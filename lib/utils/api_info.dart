import 'package:hasura_connect/hasura_connect.dart';

const HasuraBackendAPI = "https://huerto-back.herokuapp.com/v1/graphql";

class HasuraConecction {
  static HasuraConnect get conection {
    return HasuraConnect(HasuraBackendAPI);
  }
}
