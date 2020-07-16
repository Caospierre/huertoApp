import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/cultivation_guide_model.dart';
import 'package:hasura_connect/hasura_connect.dart';

class CultivationGuideRepository extends Disposable {
  final HasuraConnect connection;

  CultivationGuideRepository(this.connection);

  
  Future<Cultivation_GuideModel> createCultivationGuide(String name,String image ,String description,String guide_link,int cultivation_phaseId) async {
    var query = """
      mutation createCultivationGuide(\$name:String!,\$image:String!,\$description:String!,\$guide_link:String!, \$cultivation_phaseId:int!) {
        insert_cultivation_guide(objects: {name: \$name, image: \$image, description: \$description, guide_link: \$guide_link, id_cultivation_phase: \$cultivation_phaseId}) {
          returning {
            id
          }
        }
      }
    """;
    

    var data = await connection.mutation(query, variables: {"name": name,"image": image, "description" : description, "guide_link": guide_link});
    var id = data["data"]["insert_cultivation_guide"]["returning"][0]["id"];
    return Cultivation_GuideModel(id: id, name: name, image:image, description: description, guide_link: guide_link);
  }

  Future<Cultivation_GuideModel> deleteCultivationGuide(int id) async {
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
    return Cultivation_GuideModel(id: id);
  }


  Future<Cultivation_GuideModel> updateCultivationGuide(String name,String image ,String description,String guide_link,int cultivation_phaseId, int id) async {
    var query = """
      mutation updateCultivationGuide(\$name:String!,\$image:String!,\$description:String!,\$guide_link:String!, \$cultivation_phaseId:int!,\$id:int!) {
        update_cultivation_guide(where: {id: {_eq: \$id}}, _set: {name: \$name, image: \$image, description: \$description, guide_link: \$guide_link, id_cultivation_phase: \$cultivation_phaseId}) {
          returning {
            id
          }
        }
      }
    """;
    

    var data = await connection.mutation(query, variables: {"name": name, "image":image, "description" : description, "guide_link":guide_link, "cultivation_phaseId": cultivation_phaseId});
    var id = data["data"]["update_cultivation_guide"]["returning"][0]["id"];
    return Cultivation_GuideModel(id: id, name: name,image: image, description: description, guide_link: guide_link);
  }

  Stream<List<Cultivation_GuideModel>> getCultivationGuide() {
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
      (jsonList) => Cultivation_GuideModel.fromJsonList(jsonList["data"]["cultivation_guide"]),
    );
  }

  
  @override
  void dispose() {
    connection.dispose();
  }
}
