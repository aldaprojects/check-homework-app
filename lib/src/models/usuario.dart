// To parse this JSON data, do
//
//     final usuarios = usuariosFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    String id;
    String username;

    Usuario({
        this.id,
        this.username,
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        // "id": id,
        "username": username
    };
}
