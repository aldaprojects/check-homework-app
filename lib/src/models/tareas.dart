// To parse this JSON data, do
//
//     final tareas = tareasFromJson(jsonString);

import 'dart:convert';

import 'package:controltareas/main.dart';

Tarea tareasFromJson(String str) => Tarea.fromJson(json.decode(str));

String tareasToJson(Tarea data) => json.encode(data.toJson());

class Tarea {
    String id;
    String autor;
    String foto;
    String nota;
    Map<String, dynamic> pendientes;

    Tarea({
        this.id,
        this.autor,
        this.foto,
        this.nota,
    });

    factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        id: json["id"],
        autor: json["autor"],
        foto: json["foto"],
        nota: json["nota"],
    );

    Map<String, dynamic> toJson() => {
        // "id": id,
        "autor": autor,
        "foto": foto,
        "nota": nota,
        "pendientes" : pendientes
    };
}
