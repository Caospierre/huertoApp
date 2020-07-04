// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/cultivation_model.dart';
import 'package:huerto_app/src/models/plague_disease_model.dart';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    String name,image,period_sowing,term_harvest,description;
    int id;
    CultivationModel cultivo;
    Plague_DiseaseModel plague_disease;

    ProductModel({
        this.name,
        this.image,
        this.period_sowing,
        this.term_harvest,
        this.description,
        this.id,
        this.cultivo,
        this.plague_disease,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => new ProductModel(
        name: json["name"],
        image: json["image"],
        period_sowing: json["period_sowing"],
        term_harvest: json["term_harvest"],
        description: json["description"],
        id: json["id"],
        cultivo: CultivationModel.fromJson(json["cultivo"]),
        plague_disease: Plague_DiseaseModel.fromJson(json["plague_disease"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "period_sowing": period_sowing,
        "term_harvest": term_harvest,
        "description": description,
        "id": id,
        "cultivo": cultivo.toJson(),
        "plague_disease": plague_disease.toJson(),
    };


    static List<ProductModel> fromJsonList(List list){
      if(list == null) return null;
      return list
        .map((item) => ProductModel.fromJson(item))
        .toList();
    }
}