// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/plague_disease_model.dart';
import 'package:huerto_app/src/models/user_cultivation_phase_model.dart';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String name, photo, description, periodSowing, termHarvest;
  List<UserCultivationPhaseModel> cultivationPhase;
  int id;
  Plague_DiseaseModel plagueDisease;

  ProductModel(
      {this.id,
      this.name,
      this.photo,
      this.periodSowing,
      this.termHarvest,
      this.description,
      this.plagueDisease,
      this.cultivationPhase});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    ProductModel product = new ProductModel(
      id: json["id"],
      name: json["name"],
      photo: json["photo"],
      periodSowing: json["periodSowing"],
      termHarvest: json["termHarvest"],
      description: json["description"],
      cultivationPhase: new List<UserCultivationPhaseModel>(),
    );

    return product;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "periodSowing": periodSowing,
        "termHarvest": termHarvest,
        "description": description,
        "cultivationPhase": cultivationPhase,
      };

  static List<ProductModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => ProductModel.fromJson(item)).toList();
  }
}
