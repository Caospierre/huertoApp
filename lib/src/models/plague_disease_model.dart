// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';


Plague_DiseaseModel plague_DiseaseModelFromJson(String str) => Plague_DiseaseModel.fromJson(json.decode(str));

String plague_DiseaseModelToJson(Plague_DiseaseModel data) => json.encode(data.toJson());

class Plague_DiseaseModel {
    String name,description,image,damage;
    int id;

    Plague_DiseaseModel({
        this.name,
        this.image,
        this.description,
        this.damage,
        this.id,
    });

    factory Plague_DiseaseModel.fromJson(Map<String, dynamic> json) => new Plague_DiseaseModel(
        name: json["name"],
        image: json["image"],
        description: json["description"],
        damage: json["damage"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "description":description,
        "damage": damage,
        "id": id,
    };


    static List<Plague_DiseaseModel> fromJsonList(List list){
      if(list == null) return null;
      return list
        .map((item) => Plague_DiseaseModel.fromJson(item))
        .toList();
    }
}