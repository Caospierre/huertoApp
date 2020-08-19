import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/cultivation_guide_model.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/utils/api_info.dart';

class CultivationGuideRepository extends Disposable {
  HasuraConnect connection;

  CultivationGuideRepository() {
    this.connection = HasuraConecction.conection;
  }

  Future<CultivationGuideModel> createCultivationGuide(
    String name,
    String image,
    String description,
  ) async {
    var query = """
      mutation createCultivationGuide(\$name:String!,\$image:String!,\$description:String!,\$guide_link:String!, \$cultivation_phaseId:int!) {
        insert_cultivation_guide(objects: {name: \$name, image: \$image, description: \$description, guide_link: \$guide_link, id_cultivation_phase: \$cultivation_phaseId}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {
      "name": name,
      "image": image,
      "description": description,
    });
    var id = data["data"]["insert_cultivation_guide"]["returning"][0]["id"];
    return CultivationGuideModel(
      id: id,
      name: name,
      image: image,
      description: description,
    );
  }

  Future<CultivationGuideModel> deleteCultivationGuide(int id) async {
    var query = """
      mutation deleteCultivationGuide(\$id:int!) {
        delete_cultivation_guide(where: {id: {_eq: \$id}}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {});
    var id = data["data"]["delete_cultivation_guide"]["returning"][0]["id"];
    return CultivationGuideModel(id: id);
  }

  Future<CultivationGuideModel> updateCultivationGuide(
      String name,
      String image,
      String description,
      String guide_link,
      int cultivation_phaseId,
      int id) async {
    var query = """
      mutation updateCultivationGuide(\$name:String!,\$image:String!,\$description:String!,\$guide_link:String!, \$cultivation_phaseId:int!,\$id:int!) {
        update_cultivation_guide(where: {id: {_eq: \$id}}, _set: {name: \$name, image: \$image, description: \$description, guide_link: \$guide_link, id_cultivation_phase: \$cultivation_phaseId}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {
      "name": name,
      "image": image,
      "description": description,
      "guide_link": guide_link,
      "cultivation_phaseId": cultivation_phaseId
    });
    var id = data["data"]["update_cultivation_guide"]["returning"][0]["id"];
    return CultivationGuideModel(
        id: id,
        name: name,
        image: image,
        description: description,
        guide_link: guide_link);
  }

  Stream<List<CultivationGuideModel>> getCultivationGuide() {
    var query = """
      subscription {
        cultivation_guide(order_by: {id: asc}) {
          name
          image
          description
          guide_link
          cultivation_phase {
            id
            name
          }
        }
      }
    """;

    Snapshot snapshot = connection.subscription(query);
    return snapshot.stream.map(
      (jsonList) => CultivationGuideModel.fromJsonList(
          jsonList["data"]["cultivation_guide"]),
    );
  }

  @override
  void dispose() {
    connection.dispose();
  }
}
