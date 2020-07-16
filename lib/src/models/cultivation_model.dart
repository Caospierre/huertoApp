// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

CultivationModel cultivationModelFromJson(String str) => CultivationModel.fromJson(json.decode(str));

String cultivationModelToJson(CultivationModel data) => json.encode(data.toJson());

class CultivationModel {
    String name,description;
    Timestamped date_creation;
    int id;
    UserModel user;

    CultivationModel({
        this.name,
        this.description,
        this.date_creation,
        this.id,
        this.user,
    });

    factory CultivationModel.fromJson(Map<String, dynamic> json) => new CultivationModel(
        name: json["name"],
        description: json["description"],
        date_creation: json["date_creation"],
        id: json["id"],
        user: UserModel.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description":description,
        "date_creation":date_creation,
        "id": id,
        "user": user.toJson(),
    };


    static List<CultivationModel> fromJsonList(List list){
      if(list == null) return null;
      return list
        .map((item) => CultivationModel.fromJson(item))
        .toList();
    }
}