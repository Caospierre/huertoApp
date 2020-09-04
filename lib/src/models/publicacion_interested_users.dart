// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/models/user_model.dart';

PublicationInterestedUserModel publicationInterestedUserModelFromJson(
        String str) =>
    PublicationInterestedUserModel.fromJson(json.decode(str));

String publicationInterestedUserModelToJson(PublicationModel data) =>
    json.encode(data.toJson());

class PublicationInterestedUserModel {
  int id;

  int userOwn;

  PublicationModel publication;
  UserModel users;

  PublicationInterestedUserModel({
    this.id,
    this.userOwn,
    this.publication,
    this.users,
  });

  factory PublicationInterestedUserModel.fromJson(Map<String, dynamic> json) {
    return new PublicationInterestedUserModel(
      id: json["id"],
      userOwn: json["own_user_id"],
      publication: PublicationModel.fromJson(json["publication"]),
      users: UserModel.fromJson(json["user"]),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "userOwn": userOwn,
        "cultivation": publication.toJson(),
        "users": users.toJson(),
      };

  static List<PublicationInterestedUserModel> fromJsonList(List list) {
    if (list == null) {
      return null;
    }

    return list
        .map((item) => PublicationInterestedUserModel.fromJson(item))
        .toList();
  }
}
