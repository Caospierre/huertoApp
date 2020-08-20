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
  String description, name, image;
  int id;

  UserCultivationPhaseModel(
      {this.statePhase, this.description, this.id, this.image, this.name});

  factory UserCultivationPhaseModel.fromJson(Map<String, dynamic> json) =>
      new UserCultivationPhaseModel(
        statePhase: json["state_phase"],
        description: json["description"],
        name: json["name"],
        image: json["image"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "statePhase": statePhase,
        "description": description,
        "name": name,
        "image": image,
        "id": id,
      };

  static List<UserCultivationPhaseModel> fromJsonList(List list) {
    if (list == null) return null;
    return list
        .map((item) => UserCultivationPhaseModel.fromJson(item))
        .toList();
  }
}
