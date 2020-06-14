// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String name,password,email,phone;
    int id;

    UserModel({
        this.name,
        this.id,
        this.password,
        this.email,
        this.phone,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => new UserModel(
        name: json["name"],
        id: json["id"],
        password: json["password"],
        email: json["email"],
        phone: json["phone"],
        

    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "password":password,
        "email":email,
        "phone":phone
    };
}
