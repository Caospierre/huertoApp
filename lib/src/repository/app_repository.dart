import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/publicacion_interested_users.dart';
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

  Future<bool> isBuy(int iduser, int idpub) async {
    var query = """
      getUser(\$idpub:Int!,\$iduser:Int!){
        publicacion_interested_users(where: {id_user: {_eq: \$iduser}, _and: {publication: {id: {_eq: \$idpub}}}}) {
          id
        }
      }

    """;

    var data = await HasuraConecction.conection.query(query, variables: {
      "iduser": iduser,
      "idpub": idpub,
    });

    if (data["data"]["publicacion_interested_users"].isEmpty) {
      return false;
    } else {
      print(data.toString());
      return true;
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

  Future<UserModel> updateUser(String iduser, String phone) async {
    var query = """
      mutation createUser(\$id:Int!,\$phone:String!) {
          update_users(where: {id: {_eq: \$id}}, _set: {phone: \$phone})
          {
            returning{
              id
            }
          }
        }
      }
    """;

    var data = await HasuraConecction.conection
        .mutation(query, variables: {"id": iduser, "phone": phone});
    var id = data["data"]["update_users"]["returning"][0]["id"];
    return UserModel(id: id);
  }

  Stream<List<PublicationInterestedUserModel>> getuserInterestedMyPublication(
      int idUser) {
    var query = """
      subscription userInterestedMyPublication(\$data:Int!)  {
        publicacion_interested_users(where: {publication: {isChecked: {_eq: false}}, own_user_id: {_eq: \$data}}) {     
          id
          own_user_id
          user {
            id
            email
            name
            phone
          }
          publication {
            id
            location
            date
            distance
            priceScale
            rating
            type
            description
            isChecked
            isActive          
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
                description               
              }
            }
            user_cultivation_phases(order_by: {level_id: asc}) {
              statePhase
              description
              name
              image
              id
              level_id
              steps
            }
          }

        }

      }
    """;

    Snapshot snapshot = HasuraConecction.conection
        .subscription(query, variables: {"data": idUser});
    ;
    return snapshot.stream.map(
      (jsonList) => PublicationInterestedUserModel.fromJsonList(
          jsonList["data"]["publicacion_interested_users"]),
    );
  }

  Stream<List<PublicationModel>> getPublications(int idUser) {
    var query = """
      subscription getPubs(\$data:Int!)  {
        publications  (where: {isActive: {_eq: true}, id_usuario: {_neq: \$data}, isChecked: {_eq: false}}) {
            id
            location
            date
            distance
            priceScale
            rating
            type
            description
            isChecked
            isActive            
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
                description               
              }
            }
            user_cultivation_phases(order_by: {level_id: asc}) {
              statePhase
              description
              name
              image
              id
              level_id
              steps
            }            
          }
      }
    """;

    Snapshot snapshot = HasuraConecction.conection
        .subscription(query, variables: {"data": idUser});
    ;
    return snapshot.stream.map(
      (jsonList) =>
          PublicationModel.fromJsonList(jsonList["data"]["publications"]),
    );
  }

  Stream<List<PublicationModel>> getUserPublications(int idUser) {
    var query = """
      subscription getMyPubs(\$data:Int!) {
        publications(where: {isActive: {_eq: false}, id_usuario: {_eq:  \$data}, isChecked: {_eq: false}}) {
            id
            location
            date
            distance
            priceScale
            rating
            type
            description
            isChecked
            isActive            
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
               description
              }
            }
            user_cultivation_phases(order_by: {level_id: asc}) {
              statePhase
              description
              name
              image
              id
              level_id
              steps
            }            
          }
      }
    """;

    Snapshot snapshot = HasuraConecction.conection
        .subscription(query, variables: {"data": idUser});
    return snapshot.stream.map(
      (jsonList) =>
          PublicationModel.fromJsonList(jsonList["data"]["publications"]),
    );
  }

  Stream<List<PublicationModel>> getTransaccion(int idUser) {
    var query = """
      subscription getTransaccion(\$data:Int!) {
        publications(where: { user_transaccio_id: {_eq: \$data}, isChecked: {_eq: true}})  {
            id
            location
            date
            distance
            priceScale
            rating
            type
            description
            isChecked
            isActive
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
                description
              }
            }
            user_cultivation_phases(order_by: {level_id: asc}) {
              statePhase
              description
              name
              image
              id
              level_id
              steps
            }            
          }
      }
    """;

    Snapshot snapshot = HasuraConecction.conection
        .subscription(query, variables: {"data": idUser});
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
