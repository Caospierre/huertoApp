import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/src/models/cultivation_phase_model.dart';
import 'package:huerto_app/src/models/user_cultivation_phase_model.dart';
import 'package:huerto_app/utils/api_info.dart';

class CultivationPhaseRepository extends Disposable {
  HasuraConnect connection;

  CultivationPhaseRepository() {
    this.connection = HasuraConecction.conection;
  }

  Future<CultivationPhaseModel> createCultivationPhase(
      bool statePphase,
      String name,
      String image,
      String duration,
      String description,
      int productId) async {
    var query = """
      mutation createCultivationPhasse(\$state_phase:bool!,\$name:String!,\$image:String!,\$duration:String!,\$description:String!, \$productId:int!) {
        insert_cultivation_phase(objects: {state_phase: \$state_phase, name: \$name, image: \$image, duration: \$duration", description: \$description, id_producto: \$productId}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {
      "name": name,
      "image": image,
      "durarion": duration,
      "description": description
    });
    var id = data["data"]["insert_cultivation_guide"]["returning"][0]["id"];
    return CultivationPhaseModel(
        id: id,
        name: name,
        image: image,
        duration: duration,
        description: description);
  }

  Future<CultivationPhaseModel> deleteCultivationPhase(int id) async {
    var query = """
      mutation deleteCultivationPhase(\$id:int!) {
        delete_cultivation_phase(where: {id: {_eq: 4}}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {});
    var id = data["data"]["delete_cultivation_phase"]["returning"][0]["id"];
    return CultivationPhaseModel(id: id);
  }

  Future<CultivationPhaseModel> updateCultivationPhase(
      bool statePhase,
      String name,
      String image,
      String duration,
      String description,
      int productId,
      int id) async {
    var query = """
      mutation updateCultivationPhase(\$state_phase:bool!,\$name:String!,\$image:String!,\$duration:String!,\$description:String!, \$productId:int!,\$id:int!) {
        update_cultivation_phase(where: {id: {_eq: \$id}}, _set: {state_phase: \$state_phase, name: \$name, image: \$image, duration: \$duration, description: \$description, id_producto: \$productId}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {
      "statePhase": statePhase,
      "name": name,
      "image": image,
      "duration": duration,
      "description": description,
      "id_producto": productId
    });
    var id = data["data"]["update_cultivation_phase"]["returning"][0]["id"];
    return CultivationPhaseModel(
        id: id,
        statePhase: statePhase,
        name: name,
        image: image,
        duration: duration,
        description: description);
  }

  Stream<List<UserCultivationPhaseModel>> getUserCultivationPhase(
      int idpublication) {
    var query = """
      subscription getUserCultivationPhase(\$idpublication:Int!) {
        user_cultivation_phase(where: {id_publication: {_eq: \$idpublication}}, order_by: {description: asc}) {
          statePhase
          description
          name
          image
          id
        }
      }
    """;

    Snapshot snapshot = connection
        .subscription(query, variables: {"idpublication": idpublication});
    return snapshot.stream.map(
      (jsonList) => UserCultivationPhaseModel.fromJsonList(
          jsonList["data"]["user_cultivation_phase"]),
    );
  }

  @override
  void dispose() {
    connection.dispose();
  }
}
