import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/cultivation_model.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/src/models/cultivation_phase_model.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/models/user_cultivation_phase_model.dart';
import 'package:huerto_app/src/repository/cultivation_phase_repository.dart';
import 'package:huerto_app/utils/api_info.dart';

class CultivationRepository extends Disposable {
  HasuraConnect connection;

  CultivationRepository() {
    this.connection = HasuraConnect(HasuraBackendAPI);
  }
  Future<CultivationModel> createCultivation(
      String name, String description, int productId, int userId) async {
    var query = """
      mutation createCultivation(\$name:String!, \$description:String!, \$productId:Int!, \$userId:Int!) {
        insert_cultivation(objects: {name: \$name, description: \$description, id_product: \$productId, id_usuario: \$userId}) {
          returning {
            id
          }
        }
      }
       
    """;

    var data = await connection.mutation(query, variables: {
      "name": name,
      "description": description,
      "productId": productId,
      "userId": userId
    });
    var id = data["data"]["insert_cultivation"]["returning"][0]["id"];
    PublicationModel pub = await this.createPublicatioTemp(id, userId);
    List<CultivationPhaseModel> phaselist =
        await new CultivationPhaseRepository()
            .getCultivationPhaseById(productId);
    if (phaselist != null) {
      phaselist.forEach((phase) {
        this.insertUserCultivationPhase(phase.id, pub.id, phase.name,
            phase.description, phase.image, phase.level);
      });
    }
    return CultivationModel(id: id);
  }

  Future<PublicationModel> createPublicatioTemp(
      int cultivoId, int userId) async {
    var query = """
        mutation createPubsTemp( \$cultivoId:Int!, \$userId:Int!) {
          insert_publications(objects: {id_cultivo:  \$cultivoId, id_usuario:  \$userId,distance:"5km away",rating:5 description:"Indefinido" priceScale:0 ,type:"Indefinido",isActive:false }) {
              returning{
              id
            }
          }
        }       
    """;

    var data = await connection
        .mutation(query, variables: {"cultivoId": cultivoId, "userId": userId});
    var id = data["data"]["insert_publications"]["returning"][0]["id"];
    return PublicationModel(id: id);
  }

  Future<CultivationModel> deleteCultivation(int id) async {
    var query = """
      mutation deleteCultivation(\$id:int!) {
        delete_cultivation(where: {id: {_eq: \$id}}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {});
    var id = data["data"]["delete_cultivation"]["returning"][0]["id"];
    return CultivationModel(id: id);
  }

  Future<UserCultivationPhaseModel> insertUserCultivationPhase(
      int idphase,
      int idpub,
      String name,
      String description,
      String image,
      int level) async {
    var query = """
      mutation insertUserCultivationPhase(\$idphase:Int!,\$idpub:Int!,\$level:Int!,\$name:String!, \$description:String!,\$image:String!) {
          insert_user_cultivation_phase(objects: {id_phase: \$idphase, id_publication: \$idpub, name: \$name, description: \$description, image: \$image, level_id: \$level}){
              returning{
                id
              }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {
      "idphase": idphase,
      "idpub": idpub,
      "name": name,
      "description": description,
      "image": image,
      "level": level
    });
    var id =
        data["data"]["insert_user_cultivation_phase"]["returning"][0]["id"];
    return UserCultivationPhaseModel(id: id);
  }

  Future<CultivationModel> updateCultivation(
      String name, String description, int id) async {
    var query = """
      mutation updateCultivation(\$name:String!, \$description:String!, \$id:int!) {
        update_cultivation(where: {id: {_eq: \$id}}, _set: {name: \$name, description: \$description}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection
        .mutation(query, variables: {"name": name, "description": description});
    var id = data["data"]["update_cultivation"]["returning"][0]["id"];
    return CultivationModel(id: id, name: name, description: description);
  }

  Stream<List<CultivationModel>> getCultivation() {
    var query = """
      subscription {
        cultivation(order_by: {id: asc}) {
          name
          description
          date_creation
          user {
            id
            name
          }
          product{
            id
            name
          }
        }
      }
    """;

    Snapshot snapshot = connection.subscription(query);
    return snapshot.stream.map(
      (jsonList) =>
          CultivationModel.fromJsonList(jsonList["data"]["cultivation"]),
    );
  }

  Stream<List<CultivationModel>> getProduct() {
    var query = """
      subscription {
        product(order_by: {name: asc}) {
          id
          name
        }
      }
    """;

    Snapshot snapshot = connection.subscription(query);
    return snapshot.stream.map(
      (jsonList) =>
          CultivationModel.fromJsonList(jsonList["data"]["cultivation"]),
    );
  }

  @override
  void dispose() {
    connection.dispose();
  }
}
