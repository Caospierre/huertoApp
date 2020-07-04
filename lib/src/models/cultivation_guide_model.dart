// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/cultivation_phase_model.dart';


Cultivation_GuideModel cultivation_GuideModelFromJson(String str) => Cultivation_GuideModel.fromJson(json.decode(str));

String cultivation_GuideModelToJson(Cultivation_GuideModel data) => json.encode(data.toJson());

class Cultivation_GuideModel {
    String name,image,description,guide_link;
    int id;
    Cultivation_PhaseModel cultivation_phase;

    Cultivation_GuideModel({
        this.name,
        this.image,
        this.description,
        this.guide_link,
        this.id,
        this.cultivation_phase,
    });

    factory Cultivation_GuideModel.fromJson(Map<String, dynamic> json) => new Cultivation_GuideModel(
        name: json["name"],
        image: json["image"],
        description: json["description"],
        guide_link: json["guide_link"],
        id: json["id"],
        cultivation_phase: Cultivation_PhaseModel.fromJson(json["cultivation_phase"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "description": description,
        "guide_link": guide_link,
        "id": id,
        "cultivation_phase": cultivation_phase.toJson(),
    };


    static List<Cultivation_GuideModel> fromJsonList(List list){
      if(list == null) return null;
      return list
        .map((item) => Cultivation_GuideModel.fromJson(item))
        .toList();
    }
}