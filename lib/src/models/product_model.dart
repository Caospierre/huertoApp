// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:huerto_app/src/models/plague_disease_model.dart';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String name, photo, description, period_sowing, term_harvest;
  int id;
  Plague_DiseaseModel plague_disease;

  ProductModel({
    this.name,
    this.photo,
    this.period_sowing,
    this.term_harvest,
    this.description,
    this.id,
    this.plague_disease,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => new ProductModel(
        name: json["name"],
        photo: json["photo"],
        period_sowing: json["period_sowing"],
        term_harvest: json["term_harvest"],
        description: json["description"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "photo": photo,
        "period_sowing": period_sowing,
        "term_harvest": term_harvest,
        "description": description,
        "id": id,
      };

  static List<ProductModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => ProductModel.fromJson(item)).toList();
  }
}
