// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/product_model.dart';


Cultivation_PhaseModel cultivation_PhaseModelFromJson(String str) => Cultivation_PhaseModel.fromJson(json.decode(str));

String cultivation_PhaseModelToJson(Cultivation_PhaseModel data) => json.encode(data.toJson());

class Cultivation_PhaseModel {
    bool state_phase;
    String name,image,duration,description;
    int id;
    ProductModel product;

    Cultivation_PhaseModel({
        this.state_phase,
        this.name,
        this.image,
        this.duration,
        this.description,
        this.id,
        this.product,
    });

    factory Cultivation_PhaseModel.fromJson(Map<String, dynamic> json) => new Cultivation_PhaseModel(
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
        "description":description,
        "id": id,
        "product": product.toJson(),
    };


    static List<Cultivation_PhaseModel> fromJsonList(List list){
      if(list == null) return null;
      return list
        .map((item) => Cultivation_PhaseModel.fromJson(item))
        .toList();
    }
}