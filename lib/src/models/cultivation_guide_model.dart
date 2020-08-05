// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/cultivation_phase_model.dart';

CultivationGuideModel cultivationGuideModelFromJson(String str) =>
    CultivationGuideModel.fromJson(json.decode(str));

String cultivationGuideModelToJson(CultivationGuideModel data) =>
    json.encode(data.toJson());

class CultivationGuideModel {
  String name, image, description, guide_link;
  int id;
  CultivationPhaseModel cultivation_phase;

  CultivationGuideModel({
    this.name,
    this.image,
    this.description,
    this.guide_link,
    this.id,
    this.cultivation_phase,
  });

  factory CultivationGuideModel.fromJson(Map<String, dynamic> json) =>
      new CultivationGuideModel(
        name: json["name"],
        image: json["image"],
        description: json["description"],
        guide_link: json["guide_link"],
        id: json["id"],
        cultivation_phase:
            CultivationPhaseModel.fromJson(json["cultivation_phase"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "description": description,
        "guide_link": guide_link,
        "id": id,
        "cultivation_phase": cultivation_phase.toJson(),
      };

  static List<CultivationGuideModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => CultivationGuideModel.fromJson(item)).toList();
  }
}
