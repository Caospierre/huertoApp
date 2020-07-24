import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:get_it/get_it.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/src/models/cultivation_phase_model.dart';
import 'package:huerto_app/src/services/init_services.dart';

class CultivationPhaseRepository extends Disposable {
  HasuraConnect connection;

  CultivationPhaseRepository() {
    this.connection = GetIt.I<InitServices>().hasuraService.hasuraConect;
  }
  Future<Cultivation_PhaseModel> createCultivationPhase(
      bool state_phase,
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
    return Cultivation_PhaseModel(
        id: id,
        name: name,
        image: image,
        duration: duration,
        description: description);
  }

  Future<Cultivation_PhaseModel> deleteCultivationPhase(int id) async {
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
    return Cultivation_PhaseModel(id: id);
  }

  Future<Cultivation_PhaseModel> updateCultivationPhase(
      bool state_phase,
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
      "state_phase": state_phase,
      "name": name,
      "image": image,
      "duration": duration,
      "description": description,
      "id_producto": productId
    });
    var id = data["data"]["update_cultivation_phase"]["returning"][0]["id"];
    return Cultivation_PhaseModel(
        id: id,
        state_phase: state_phase,
        name: name,
        image: image,
        duration: duration,
        description: description);
  }

  Stream<List<Cultivation_PhaseModel>> getCultivationPhase() {
    var query = """
      subscription {
        cultivation_phase(order_by: {id: asc}) {
          state_phase
          name
          image
          duration
          description
          producto {
            id
            name
          }
        }
      }
    """;

    Snapshot snapshot = connection.subscription(query);
    return snapshot.stream.map(
      (jsonList) => Cultivation_PhaseModel.fromJsonList(
          jsonList["data"]["cultivation_phase"]),
    );
  }

  @override
  void dispose() {
    connection.dispose();
  }
}
