// To parse this JSON data, do
//
//     final producto = productoFromJson(jsonString);
import 'dart:convert';

import 'package:arturo_bruna_app/state-management-project/data/datasource/api_repository_impl.dart';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
  Producto({
    this.id,
    this.nombre,
    this.codigo,
    this.descripcion,
    this.preciocompra,
    this.precioventa,
    this.imagen,
    this.stock,
    this.stockminimo,
  });

  int id;
  String nombre;
  String codigo;
  String descripcion;
  int preciocompra;
  int precioventa;
  String imagen;
  int stock;
  int stockminimo;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"] as int,
        nombre: json["nombre"] as String,
        codigo: json["codigo"] as String,
        descripcion: json["descripcion"] as String,
        preciocompra: json["preciocompra"] as int,
        precioventa: json["precioventa"] as int,
        imagen: ApiRepositoryImpl.urlProductImage + json["imagen"],
        stock: json["stock"] as int,
        stockminimo: json["stockminimo"] as int,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "codigo": codigo,
        "descripcion": descripcion,
        "preciocompra": preciocompra,
        "precioventa": precioventa,
        "imagen": imagen,
        "stock": stock,
        "stockminimo": stockminimo,
      };

  @override
  String toString() {
    return 'Instancia de Producto: $nombre';
  }
}
