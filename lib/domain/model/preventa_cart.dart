
import 'package:arturo_bruna_app/domain/model/product.dart';

class PreSaleCart {
  final Producto product;
  int quantity = 1;
  int precioLinea = 0;
  PreSaleCart({
    this.product,
    this.quantity = 1,
    this.precioLinea,
  });

  @override
  String toString() {
    return 'Instancia de PreSaleCart: ${product.nombre + '-' + precioLinea.toString()}';
  }

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "quantity": quantity,
        "precioLinea": precioLinea,
      };
}
