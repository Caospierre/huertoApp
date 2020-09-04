import 'package:hasura_connect/hasura_connect.dart';

const HasuraBackendAPI = "https://huerto-back.herokuapp.com/v1/graphql";
const String serverToken =
    'AAAAzuUQuB4:APA91bEf-NEe8pcusP6PfeFemvO_dYywEK9r7i_VJsOSZneYiCUQvQS9OPfDaGwxtET16vXcxARqWjmzOq8ScyUhJHyHJGRR_5V48Yhdj8AmFNNrXCRYnzWYyJ5v6DsuUsohuxkRUuyvs';

class HasuraConecction {
  static HasuraConnect get conection {
    return HasuraConnect(HasuraBackendAPI);
  }
}
