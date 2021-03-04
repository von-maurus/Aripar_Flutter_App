// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);
import 'dart:convert';

import 'package:arturo_bruna_app/data/api_repository_impl.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    this.id,
    this.nombre,
    this.username,
    this.correo,
    this.tipo,
    this.fono,
    this.comision,
    this.imagen,
    this.estado,
  });

  int id;
  String nombre;
  String username;
  String correo;
  int tipo;
  String fono;
  int comision;
  String imagen;
  int estado;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"] as int,
        nombre: json["nombre"] as String,
        username: json["username"] as String,
        correo: json["correo"] as String,
        tipo: json["tipo"] as int,
        fono: json["fono"] as String,
        comision: json["comision"] as int,
        imagen: json["imagen"] == null
            ? null
            : ApiRepositoryImpl.urlUserImage + json["imagen"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "username": username,
        "correo": correo,
        "tipo": tipo,
        "fono": fono,
        "comision": comision,
        "imagen": imagen,
        "estado": estado,
      };

  @override
  String toString() {
    return 'Instancia de Usuario: $nombre - $username - $imagen';
  }
}
