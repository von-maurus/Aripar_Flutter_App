import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';

class PreventaCart {
  PreventaCart({this.product, this.quantity = 1, this.precioLinea});
  final Producto product;
  int quantity;
  double precioLinea;
}
