// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/user_model.dart';

publicationModel publicationModelFromJson(String str) => publicationModel.fromJson(json.decode(str));

String publicationModelToJson(publicationModel data) => json.encode(data.toJson());

class publicationModel {
    String content;
    int id;
    UserModel user;

    publicationModel({
        this.content,
        this.id,
        this.user,
    });

    factory publicationModel.fromJson(Map<String, dynamic> json) => new publicationModel(
        content: json["content"],
        id: json["id"],
        user: UserModel.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "id": id,
        "user": user.toJson(),
    };


    static List<publicationModel> fromJsonList(List list){
      if(list == null) return null;
      return list
        .map((item) => publicationModel.fromJson(item))
        .toList();
    }
}