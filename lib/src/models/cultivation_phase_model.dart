// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/product_model.dart';

CultivationPhaseModel cultivationPhaseModelFromJson(String str) =>
    CultivationPhaseModel.fromJson(json.decode(str));

String cultivationPhaseModelToJson(CultivationPhaseModel data) =>
    json.encode(data.toJson());

class CultivationPhaseModel {
  bool statePhase;
  String name, image, duration, description;
  int id;
  ProductModel product;

  CultivationPhaseModel({
    this.statePhase,
    this.name,
    this.image,
    this.duration,
    this.description,
    this.id,
    this.product,
  });

  factory CultivationPhaseModel.fromJson(Map<String, dynamic> json) =>
      new CultivationPhaseModel(
        statePhase: json["state_phase"],
        name: json["name"],
        image: json["image"],
        duration: json["duration"],
        description: json["description"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "duration": duration,
        "statePhase": statePhase,
        "description": description,
        "id": id,
      };

  static List<CultivationPhaseModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => CultivationPhaseModel.fromJson(item)).toList();
  }
}
