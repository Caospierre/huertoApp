import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/src/models/cultivation_phase_model.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/models/user_cultivation_phase_model.dart';
import 'package:huerto_app/src/models/user_model.dart';
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

  Future<UserCultivationPhaseModel> updatePhaseState(
      bool statePhase, DateTime notification, int idphase) async {
    var query = """
      mutation updateUserPhase(\$statePhase:Boolean!,\$notification:timestamp!,\$id:Int!) {
          update_user_cultivation_phase(_set: {statePhase: \$statePhase, notification: \$notification}, where: {id: {_eq: \$id}}) {
            returning {
              id
            }
          }
      }
    """;

    var data = await connection.mutation(query, variables: {
      "statePhase": statePhase,
      "id": idphase,
      "notification": notification.toString(),
    });

    var id =
        data["data"]["update_user_cultivation_phase"]["returning"][0]["id"];
    return UserCultivationPhaseModel(
      id: id,
    );
  }

  Future<UserCultivationPhaseModel> updatePhaseStateNext(
      bool statePhase, int idphase) async {
    print(idphase);
    var query = """
      mutation updateUserPhase(\$statePhase:Boolean!,\$id:Int!) {
          update_user_cultivation_phase(_set: {statePhase: \$statePhase}, where: {id: {_eq: \$id}}) {
            returning {
              id
            }
          }
      }
    """;

    var data = await connection.mutation(query, variables: {
      "statePhase": statePhase,
      "id": idphase,
    });

    var id =
        data["data"]["update_user_cultivation_phase"]["returning"][0]["id"];
    print("Updated Phase");

    return UserCultivationPhaseModel(
      id: id,
    );
  }

  Stream<List<UserCultivationPhaseModel>> getUserCultivationPhase(
      int idpublication) {
    var query = """
      subscription getUserCultivationPhase(\$idpublication:Int!) {
        user_cultivation_phase(where: {id_publication: {_eq: \$idpublication}}, order_by: {level_id: asc}) {
          statePhase
          description
          name
          image
          id
          level_id
          steps
        }
      }
    """;

    Snapshot snapshot = connection
        .subscription(query, variables: {"idpublication": idpublication});
    print("Updated Phase");
    return snapshot.stream.map(
      (jsonList) => UserCultivationPhaseModel.fromJsonList(
          jsonList["data"]["user_cultivation_phase"]),
    );
  }

  Future<List<CultivationPhaseModel>> getCultivationPhaseById(
      int _idproduct) async {
    var query = """
      getCultivationPhaseById(\$_idproduct:Int!){
        cultivation_phase(where: {id_producto: {_eq: \$_idproduct}}, order_by: {name: asc}) {
          image
          name
          id
          level_id
          description
          statePhase
          steps
        }
      }
    """;

    var data =
        await connection.query(query, variables: {"_idproduct": _idproduct});

    if (data["data"]["cultivation_phase"].isEmpty) {
      return null;
    } else {
      return CultivationPhaseModel.fromJsonList(
          data["data"]["cultivation_phase"]);
    }
  }

  Future<UserModel> updateUserPhone(int iduser, String phone) async {
    var query = """
      mutation updateUser(\$id:Int!,\$phone:String!) {
          update_users(where: {id: {_eq: \$id}}, _set: {phone: \$phone})
           {
            returning{
              id
            }
          }
      }
    """;

    var data = await connection
        .mutation(query, variables: {"id": iduser, "phone": phone});
    var id = data["data"]["update_users"]["returning"][0]["id"];
    return UserModel(id: id);
  }

  Future<PublicationModel> updateActivePub(int idpub) async {
    var query = """
      mutation updateUpublication(\$id:Int!) {
          update_publications(where: {id: {_eq: \$id}}, _set: {isActive:true})
           {
            returning{
              id
            }
          }
      }
    """;

    var data = await connection.mutation(query, variables: {"id": idpub});
    var id = data["data"]["update_publications"]["returning"][0]["id"];
    return PublicationModel(id: id);
  }

  Future<PublicationModel> updateCheckedPub(int idpub) async {
    var query = """
      mutation updateUpublication(\$id:Int!) {
          update_publications(where: {id: {_eq: \$id}}, _set: {isCheked:true})
           {
            returning{
              id
            }
          }
      }
    """;

    var data = await connection.mutation(query, variables: {"id": idpub});
    var id = data["data"]["update_publications"]["returning"][0]["id"];
    return PublicationModel(id: id);
  }

  @override
  void dispose() {
    connection.dispose();
  }
}
