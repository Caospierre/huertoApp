// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/product_model.dart';
import 'package:huerto_app/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

CultivationModel cultivationModelFromJson(String str) =>
    CultivationModel.fromJson(json.decode(str));

String cultivationModelToJson(CultivationModel data) =>
    json.encode(data.toJson());

class CultivationModel {
  String name, description;
  Timestamped date_creation;
  int id;
  UserModel users;
  ProductModel product;

  CultivationModel({
    this.name,
    this.description,
    this.date_creation,
    this.id,
    this.users,
    this.product,
  });

  factory CultivationModel.fromJson(Map<String, dynamic> json) {
    CultivationModel temp = new CultivationModel(
      name: json["name"],
      description: json["description"],
      date_creation: json["date_creation"],
      id: json["id"],
      product: ProductModel.fromJson(json["product"]),
    );
    return temp;
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "product": product.toJson(),
        "date_creation": date_creation,
        "id": id,
        "users": users.toJson(),
      };

  static List<CultivationModel> fromJsonList(List list) {
    if (list == null) return null;
    list
        .map((item) => CultivationModel.fromJson(item))
        .toList()
        .forEach((element) {
      print(element.name);
    });
    return list.map((item) => CultivationModel.fromJson(item)).toList();
  }
}
