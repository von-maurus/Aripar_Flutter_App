import 'package:flutter/cupertino.dart';

class Usuario {
  int id, tipo, estado;
  String username, correo, nombre, fono, imagen, token;
  double comision;
  bool online;

  Usuario(
      {@required this.id,
      @required this.tipo,
      @required this.estado,
      @required this.username,
      @required this.correo,
      this.nombre,
      this.fono,
      this.imagen,
      this.comision});
}
