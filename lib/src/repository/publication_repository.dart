import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/utils/api_info.dart';

class PublicationRepository extends Disposable {
  PublicationRepository() {}
  Future<PublicationModel> getPublications(int publicationId) async {
    var query = """
      getPublications(\$data:String!){
        publications(where:{id:{_eq: \$data}}) {
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
              email
              password
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

    var data = await HasuraConecction.conection
        .query(query, variables: {"data": publicationId});
    if (data["data"]["publications"].isEmpty) {
      return null;
    } else {
      return PublicationModel.fromJson(data["data"]["publications"][0]);
    }
  }

  void checkedPublication(int _id, int _iduser) async {
    // ignore: non_constant_identifier_names
    var id = 23, user_transaccio_id = 5;
    var query = """
     mutation checkedPublication(\$id:Int!,\$user_transaccio_id:Int!) {
         update_publications_by_pk(pk_columns: {id:\$id}, _set: {isChecked: true,user_transaccio_id: \$user_transaccio_id}) {
          id
        }
      }
    """;

    var data = await HasuraConecction.conection.mutation(query,
        variables: {"id": id, "user_transaccio_id": user_transaccio_id});
    ;
    print('Update');
    print(data.toString());
  }

  @override
  void dispose() {
    HasuraConecction.conection.dispose();
  }
}
