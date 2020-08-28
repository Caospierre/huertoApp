// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

UserCultivationPhaseModel cultivationPhaseModelFromJson(String str) =>
    UserCultivationPhaseModel.fromJson(json.decode(str));

String cultivationPhaseModelToJson(UserCultivationPhaseModel data) =>
    json.encode(data.toJson());

class UserCultivationPhaseModel {
  bool statePhase;
  String description, name, image, steps;
  int id, level;

  UserCultivationPhaseModel(
      {this.statePhase,
      this.description,
      this.id,
      this.image,
      this.name,
      this.level,
      this.steps});

  factory UserCultivationPhaseModel.fromJson(Map<String, dynamic> json) =>
      new UserCultivationPhaseModel(
        statePhase: json["statePhase"],
        description: json["description"],
        name: json["name"],
        image: json["image"],
        id: json["id"],
        level: json["level_id"],
        steps: json["steps"],
      );

  Map<String, dynamic> toJson() => {
        "statePhase": statePhase,
        "description": description,
        "name": name,
        "image": image,
        "id": id,
        "level_id": level,
        "steps": steps,
      };

  static List<UserCultivationPhaseModel> fromJsonList(List list) {
    if (list == null) return null;
    return list
        .map((item) => UserCultivationPhaseModel.fromJson(item))
        .toList();
  }
}
