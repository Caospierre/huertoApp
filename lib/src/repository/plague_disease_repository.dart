import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/src/models/plague_disease_model.dart';

class PlagueDiseaseRepository extends Disposable {
  final HasuraConnect connection;

  PlagueDiseaseRepository(this.connection);

  Future<Plague_DiseaseModel> createPlagueDisease(
      String name, String image, String damge, String description) async {
    var query = """
      mutation createPlagueDisease(\$name:String!,\$image:String!,\$damge:String!,\$description:String!) {
        insert_plague_disease(objects: {name: \$name, image: \$image, damge: \$damge, description: \$description}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {
      "name": name,
      "image": image,
      "damge": damge,
      "description": description
    });
    var id = data["data"]["insert_plague_disease"]["returning"][0]["id"];
    return Plague_DiseaseModel(
        id: id,
        name: name,
        image: image,
        damage: damge,
        description: description);
  }

  Future<Plague_DiseaseModel> deletePlagueDisease(int id) async {
    var query = """
      mutation deletePlagueDisease(\$id:int!) {
        delete_plague_disease(where: {id: {_eq: \$id}}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {});
    var id = data["data"]["delete_plague_disease"]["returning"][0]["id"];
    return Plague_DiseaseModel(id: id);
  }

  Future<Plague_DiseaseModel> updatePlagueDisease(String name, String image,
      String damge, String description, int id) async {
    var query = """
      mutation updatePlagueDisease(\$name:String!,\$image:String!,\$damge:String!,\$description:String!,\$id:int) {
        update_plague_disease(where: {id: {_eq: \$id}}, _set: {name: \$name, image: \$image, damge: \$damge, description: \$description}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {
      "name": name,
      "image": image,
      "damge": damge,
      "description": description
    });
    var id = data["data"]["update_plague_disease"]["returning"][0]["id"];
    return Plague_DiseaseModel(
        id: id,
        name: name,
        image: image,
        damage: damge,
        description: description);
  }

  Stream<List<Plague_DiseaseModel>> getPlagueDisease() {
    var query = """
      subscription {
        plague_disease(order_by: {id: asc}) {
          name
          image
          damge
          description
        }
      }
    """;

    Snapshot snapshot = connection.subscription(query);
    return snapshot.stream.map(
      (jsonList) =>
          Plague_DiseaseModel.fromJsonList(jsonList["data"]["plague_disease"]),
    );
  }

  Future<Plague_DiseaseModel> getPlagueDiseaseByProduct(
    int _id_product,
  ) async {
    var query = """
      getPlagueDiseaseByProduct(\$_id_product:Int!){
        plague_disease(where: {id_product: {_eq: \$_id_product}}) {
          name
          description
          damge
          image
        }
      }
    """;

    var data =
        await connection.query(query, variables: {"_id_product": _id_product});
    if (data["data"]["cultivation_phase"].isEmpty) {
      return null;
    } else {
      return Plague_DiseaseModel.fromJson(data["data"]["cultivation_phase"][0]);
    }
  }

  @override
  void dispose() {
    connection.dispose();
  }
}
