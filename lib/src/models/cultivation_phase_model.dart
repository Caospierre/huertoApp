// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/product_model.dart';

CultivationPhaseModel cultivation_PhaseModelFromJson(String str) =>
    CultivationPhaseModel.fromJson(json.decode(str));

String cultivation_PhaseModelToJson(CultivationPhaseModel data) =>
    json.encode(data.toJson());

class CultivationPhaseModel {
  bool state_phase;
  String name, image, duration, description;
  int id;
  ProductModel product;

  CultivationPhaseModel({
    this.state_phase,
    this.name,
    this.image,
    this.duration,
    this.description,
    this.id,
    this.product,
  });

  factory CultivationPhaseModel.fromJson(Map<String, dynamic> json) =>
      new CultivationPhaseModel(
        state_phase: json["state_phase"],
        name: json["name"],
        image: json["image"],
        duration: json["duration"],
        description: json["description"],
        id: json["id"],
        product: ProductModel.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "duration": duration,
        "description": description,
        "id": id,
        "product": product.toJson(),
      };

  static List<CultivationPhaseModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => CultivationPhaseModel.fromJson(item)).toList();
  }
}
