import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/models/user_model.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/utils/api_info.dart';

class AppRepository extends Disposable {
  AppRepository() {}

  Future<UserModel> getUser(String user) async {
    var query = """
      getUser(\$data:String!){
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
        .query(query, variables: {"data": user});

    if (data["data"]["users"].isEmpty) {
      return null;
    } else {
      return UserModel.fromJson(data["data"]["users"][0]);
    }
  }

  Future<UserModel> createUser(String email) async {
    var query = """
      mutation createUser(\$email:String!) {
        insert_users(objects: {email: \$email}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await HasuraConecction.conection
        .mutation(query, variables: {"email": email});
    var id = data["data"]["insert_users"]["returning"][0]["id"];
    return UserModel(id: id, email: email);
  }

  Stream<List<PublicationModel>> getPublications() {
    var query = """
      subscription {
        publications {
            id
            location
            date
            distance
            priceScale
            rating
            type
            description
            users {
              id
              name
              email              
            }
            cultivation {
              name
              description
              id
              product {
                id
                name
                photo
              }
            }
          }
      }
    """;

    Snapshot snapshot = HasuraConecction.conection.subscription(query);
    print("data " + HasuraConecction.conection.isConnected.toString());
    return snapshot.stream.map(
      (jsonList) =>
          PublicationModel.fromJsonList(jsonList["data"]["publications"]),
    );
  }

  Future<List<PublicationModel>> getPubs() {
    var query = """
      subscription {
        publications {
            id
            location
            date
            distance
            priceScale
            rating
            type
            description
            users {
              id
              name
              email              
            }
            cultivation {
              name
              description
              id
              product {
                id
                name
                photo
              }
            }
          }
      }
    """;
    Snapshot snapshot = HasuraConecction.conection.subscription(query);

    return snapshot.stream
        .map(
          (jsonList) =>
              PublicationModel.fromJsonList(jsonList["data"]["publications"]),
        )
        .first;
  }

  Future<dynamic> sendPublication(String publication, int userId) {
    var query = """
      sendPublication(\$publication:String!,\$userId:Int!) {
        insert_publications(objects: {id_usuario: \$userId, content: \$publication}) {
          affected_rows
        }
      }
    """;

    return HasuraConecction.conection.mutation(query, variables: {
      "publication": publication,
      "userId": userId,
    });
  }

  // Future<publicationModel> random()async {
  //   var query = """
  //     subscription {
  //       publications(order_by: {id: desc}) {
  //         content
  //         id
  //         user {
  //           name
  //           id
  //         }
  //       }
  //     }
  //   """;

  //   var jsonList = await connection.query(query);
  //   var publications = publicationModel.fromJsonList(jsonList["data"]["publications"]);
  //   var randomIndex = Random().nextInt(publications.length);
  //   return publications[randomIndex];
  // }

  @override
  void dispose() {
    HasuraConecction.conection.dispose();
  }
}
