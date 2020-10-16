import 'package:meta/meta.dart';

class Usuario {
  const Usuario(
      {@required this.id,
      @required this.nombre,
      @required this.username,
      @required this.correo,
      @required this.tipo,
      this.fono,
      this.comision,
      this.imagen,
      this.estado});

  final int id;
  final String nombre;
  final String username;
  final String correo;
  final int tipo;
  final String fono;
  final int comision;
  final String imagen;
  final int estado;

  factory Usuario.empty() => Usuario(
      id: null,
      nombre: null,
      username: null,
      correo: null,
      tipo: null,
      fono: null,
      comision: null,
      imagen: null);
}
