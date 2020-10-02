import 'package:flutter/cupertino.dart';

class Producto {
  int id, stock, stockMinimo;
  String nombre, codigo, descripcion, imagen;
  double precioCompra, precioVenta;

  Producto(
      {@required this.id,
      @required this.nombre,
      @required this.codigo,
      @required this.descripcion,
      this.stock,
      this.stockMinimo,
      this.precioCompra,
      this.imagen,
      this.precioVenta});
}
