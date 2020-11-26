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
    this.tipo,
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
  int tipo;

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
        tipo: json["tipo"] as int,
      );

  Map<String, dynamic> toJson() => {
        "id": id != null ? id : null,
        "nombre": nombre,
        "rut": rut,
        "correo": correo,
        "direccion": direccion,
        "fono": fono,
        "tipopago": tipopago,
        "numerocuotas": numerocuotas,
        "estado": estado != null ? estado : 1,
        "tipo": tipo != null ? tipo : 1,
      };
  Map<String, dynamic> createToJson() => {
        "nombre": nombre,
        "rut": rut,
        "correo": correo,
        "direccion": direccion,
        "fono": fono,
        "tipopago": tipopago,
        "numerocuotas": numerocuotas,
        "tipo": tipo,
      };
  int get numDias {
    switch (numerocuotas) {
      case 1:
        return 7;
      case 2:
        return 15;
      case 3:
        return 30;
      default:
        return 7;
    }
  }

  String get tipoChanged {
    switch (tipo) {
      case 1:
        return 'Minorista';
      case 2:
        return 'Mayorista';
      default:
        return 'No especificado';
    }
  }

  @override
  String toString() {
    return 'Instancia de Cliente: $nombre - $rut - ${tipo == 1 ? 'Mayorista' : 'Minorista'}';
  }
}
