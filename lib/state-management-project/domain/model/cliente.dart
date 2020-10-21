// To parse this JSON data, do
//
//     final cliente = clienteFromJson(jsonString);

import 'dart:convert';

Cliente clienteFromJson(String str) => Cliente.fromJson(json.decode(str));

String clienteToJson(Cliente data) => json.encode(data.toJson());

class Cliente {
  Cliente({
    this.id,
    this.nombre,
    this.rut,
    this.correo,
    this.direccion,
    this.fono,
    this.tipopago,
    this.numerocuotas,
    this.estado,
  });

  int id;
  String nombre;
  String rut;
  String correo;
  String direccion;
  String fono;
  int tipopago;
  int numerocuotas;
  int estado;

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"] as int,
        nombre: json["nombre"] as String,
        rut: json["rut"] as String,
        correo: json["correo"] as String,
        direccion: json["direccion"] as String,
        fono: json["fono"] as String,
        tipopago: json["tipopago"] as int,
        numerocuotas: json["numerocuotas"] as int,
        estado: json["estado"] as int,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "rut": rut,
        "correo": correo,
        "direccion": direccion,
        "fono": fono,
        "tipopago": tipopago,
        "numerocuotas": numerocuotas,
        "estado": estado,
      };
  @override
  String toString() {
    return 'Instancia de Cliente: $nombre';
  }
}
