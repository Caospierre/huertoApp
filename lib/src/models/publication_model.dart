// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/user_model.dart';

PublicationModel publicationModelFromJson(String str) => PublicationModel.fromJson(json.decode(str));

String publicationModelToJson(PublicationModel data) => json.encode(data.toJson());

class PublicationModel {
    String content;
    int id;
    UserModel user;

    PublicationModel({
        this.content,
        this.id,
        this.user,
    });

    factory PublicationModel.fromJson(Map<String, dynamic> json) => new PublicationModel(
        content: json["content"],
        id: json["id"],
        user: UserModel.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "id": id,
        "user": user.toJson(),
    };


    static List<PublicationModel> fromJsonList(List list){
      if(list == null) return null;
      return list
        .map((item) => PublicationModel.fromJson(item))
        .toList();
    }
}