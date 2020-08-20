import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/cultivation_model.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/src/models/cultivation_phase_model.dart';
import 'package:huerto_app/src/models/publication_model.dart';
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

    this.createPublicatioTemp(id, userId);
    return CultivationModel(id: id, name: name, description: description);
  }

  Future<CultivationPhaseModel> getCultivationPhase(int idproduct) async {
    var query = """
      getUser(\$data:Int!){
        users(where: {email: {_eq: \$data}}) {
          name
          id
          password
          email
          phone

        }
      }
    """;

    var data = await HasuraConecction.conection
        .query(query, variables: {"data": idproduct});

    if (data["data"]["users"].isEmpty) {
      return null;
    } else {
      return CultivationPhaseModel.fromJson(data["data"]["users"][0]);
    }
  }

  Future<PublicationModel> createPublicatioTemp(
      int cultivoId, int userId) async {
    var query = """
        mutation createPubsTemp( \$cultivoId:Int!, \$userId:Int!) {
          insert_publications(objects: {id_cultivo:  \$cultivoId, id_usuario:  \$userId,distance:"5km away",rating:5 description:"" priceScale:0 ,type:"",isActive:true }) {
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
