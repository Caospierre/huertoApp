// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/cultivation_model.dart';
import 'package:huerto_app/src/models/user_model.dart';

PublicationModel publicationModelFromJson(String str) =>
    PublicationModel.fromJson(json.decode(str));

String publicationModelToJson(PublicationModel data) =>
    json.encode(data.toJson());

class PublicationModel {
  int id;
  CultivationModel cultivation;
  String date;
  String distance;
  String location;
  String name;
  String photo;
  String type;
  int priceScale;
  int rating;
  String description;
  UserModel users;

  PublicationModel({
    this.id,
    this.cultivation,
    this.name,
    this.photo,
    this.date,
    this.location,
    this.distance,
    this.type,
    this.priceScale,
    this.rating,
    this.description,
    this.users,
  });

  factory PublicationModel.fromJson(Map<String, dynamic> json) =>
      new PublicationModel(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        location: json["location"],
        date: json["date"],
        distance: json["distance"],
        priceScale: json["priceScale"],
        rating: json["rating"],
        type: json["type"],
        description: json["description"],
        users: UserModel.fromJson(json["users"]),
        cultivation: CultivationModel.fromJson(json["cultivation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "cultivation": cultivation.toJson(),
        "location": location,
        "date": date,
        "distance": distance,
        "priceScale": priceScale,
        "rating": rating,
        "type": type,
        "description": description,
        "users": users.toJson(),
      };

  static List<PublicationModel> fromJsonList(List list) {
    if (list == null) {
      return null;
    }

    return list.map((item) => PublicationModel.fromJson(item)).toList();
  }
}
