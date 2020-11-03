import 'impuesto.dart';

class ImpuestoProducto {
  ImpuestoProducto({
    this.id,
    this.productosId,
    this.impuestosId,
    this.impuestos,
  });

  int id;
  int productosId;
  int impuestosId;
  Impuestos impuestos;

  factory ImpuestoProducto.fromJson(Map<String, dynamic> json) =>
      ImpuestoProducto(
        id: json["id"],
        productosId: json["Productos_id"],
        impuestosId: json["Impuestos_id"],
        impuestos: Impuestos.fromJson(json["impuestos"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Productos_id": productosId,
        "Impuestos_id": impuestosId,
        "impuestos": impuestos.toJson(),
      };
}
