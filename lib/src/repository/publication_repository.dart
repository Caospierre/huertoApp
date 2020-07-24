import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/utils/api_info.dart';

class PublicationRepository extends Disposable {
  HasuraConnect connection;

  PublicationRepository() {
    this.connection = HasuraConnect(HasuraBackendAPI);
  }
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

    var data =
        await connection.query(query, variables: {"data": publicationId});
    if (data["data"]["publications"].isEmpty) {
      return null;
    } else {
      return PublicationModel.fromJson(data["data"]["publications"][0]);
    }
  }

  @override
  void dispose() {
    connection.dispose();
  }
}
