import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';

class PreSaleCart {
  final Producto product;
  int quantity;
  double precioLinea;
  PreSaleCart({this.product, this.quantity = 1, this.precioLinea});
}
