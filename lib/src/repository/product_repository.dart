import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/cultivation_model.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/src/models/product_model.dart';
import 'package:huerto_app/utils/api_info.dart';

class ProductRepository extends Disposable {
  HasuraConnect connection;

  ProductRepository() {
    this.connection = HasuraConnect(HasuraBackendAPI);
  }
  Future<CultivationModel> createProducto(
      String name, String description, int userId) async {
    var query = """
      mutation createCultivation(\$name:String!, \$description:String!, \$userId:int!) {
        insert_cultivation(objects: {name: \$name, description: \$description, id_usuario: \$userId}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection
        .mutation(query, variables: {"name": name, "description": description});
    var id = data["data"]["insert_cultivation"]["returning"][0]["id"];
    return CultivationModel(id: id, name: name, description: description);
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
        }
      }
    """;

    Snapshot snapshot = connection.subscription(query);
    return snapshot.stream.map(
      (jsonList) =>
          CultivationModel.fromJsonList(jsonList["data"]["cultivation"]),
    );
  }

  Stream<List<ProductModel>> getProducts() {
    var query = """
      subscription {
          product 
          {
            name
            id
            photo
          }
      }
    """;

    Snapshot snapshot = connection.subscription(query);
    return snapshot.stream.map(
      (jsonList) => ProductModel.fromJsonList(jsonList["data"]["product"]),
    );
  }

  @override
  void dispose() {
    connection.dispose();
  }
}
