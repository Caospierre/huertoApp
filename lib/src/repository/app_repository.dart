

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/models/user_model.dart';
import 'package:hasura_connect/hasura_connect.dart';

class AppRepository extends Disposable {
  final HasuraConnect connection;

  AppRepository(this.connection);

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

    var data = await connection.query(query, variables: {"data": user});
    if (data["data"]["users"].isEmpty) {
      return null;
    } else {
      return UserModel.fromJson(data["data"]["users"][0]);
    }
  }

  Future<UserModel> createUser(String name) async {
    var query = """
      mutation createUser(\$name:String!) {
        insert_users(objects: {name: \$name}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {"name": name});
    var id = data["data"]["insert_users"]["returning"][0]["id"];
    return UserModel(id: id, name: name);
  }

  Stream<List<publicationModel>> getPublications() {
    var query = """
      subscription {
        publications(order_by: {id: desc}) {
          content
          id
          user {
            name
            id
          }
        }
      }
    """;

    Snapshot snapshot = connection.subscription(query);
    return snapshot.stream.map(
      (jsonList) => publicationModel.fromJsonList(jsonList["data"]["publications"]),
    );
  }

  Future<dynamic> sendPublication(String publication, int userId){
    var query = """
      sendPublication(\$publication:String!,\$userId:Int!) {
        insert_publications(objects: {id_usuario: \$userId, content: \$publication}) {
          affected_rows
        }
      }
    """;

    return connection.mutation(query, variables: {
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
    connection.dispose();
  }
}
