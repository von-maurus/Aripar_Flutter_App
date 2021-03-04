class Impuestos {
  Impuestos({
    this.id,
    this.nombre,
    this.porcentaje,
  });

  int id;
  String nombre;
  double porcentaje;

  factory Impuestos.fromJson(Map<String, dynamic> json) => Impuestos(
        id: json["id"],
        nombre: json["nombre"],
        porcentaje: double.parse(json["porcentaje"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "porcentaje": porcentaje,
      };
}
