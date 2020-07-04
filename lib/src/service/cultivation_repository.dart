import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/cultivation_model.dart';
import 'package:hasura_connect/hasura_connect.dart';

class CultivationRepository extends Disposable {
  final HasuraConnect connection;

  CultivationRepository(this.connection);

  
  Future<CultivationModel> createCultivation(String name, String description, int userId) async {
    var query = """
      mutation createCultivation(\$name:String!, \$description:String!, \$userId:int!) {
        insert_cultivation(objects: {name: \$name, description: \$description, id_usuario: \$userId}) {
          returning {
            id
          }
        }
      }
    """;
    

    var data = await connection.mutation(query, variables: {"name": name, "description" : description});
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
    var id = data["data"]["insert_cultivation"]["returning"][0]["id"];
    return CultivationModel(id: id);
  }


  Future<CultivationModel> updateCultivation(String name, String description, int id) async {
    var query = """
      mutation updateCultivation(\$name:String!, \$description:String!, \$id:int!) {
        update_cultivation(where: {id: {_eq: \$id}}, _set: {name: \$name, description: \$description}) {
          returning {
            id
          }
        }
      }
    """;
    

    var data = await connection.mutation(query, variables: {"name": name, "description" : description});
    var id = data["data"]["update_cultivation"]["returning"][0]["id"];
    return CultivationModel(id: id, name: name, description: description);
  }

  Stream<List<CultivationModel>> getCultivo() {
    var query = """
      subscription {
        producto(order_by: {id: desc}) {
          nombre
          imagen
    			periodo_siembra
    			plazo_cosecha
          descripcion
          cultivo {
            nombre
            id
          }
        }
      }
    """;

    Snapshot snapshot = connection.subscription(query);
    return snapshot.stream.map(
      (jsonList) => CultivationModel.fromJsonList(jsonList["data"]["cultivation"]),
    );
  }

  
  @override
  void dispose() {
    connection.dispose();
  }
}
