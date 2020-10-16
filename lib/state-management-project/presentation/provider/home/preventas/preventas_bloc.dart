import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/product_cart.dart';
import 'package:flutter/material.dart';

class PreVentaBLoC extends ChangeNotifier {
  List<PreventaCart> preVentaList = <PreventaCart>[];
  int totalItems = 0;
  double totalPrice = 0.0;

  void add(Producto product) {
    final temp = List<PreventaCart>.from(preVentaList);
    bool found = false;
    for (PreventaCart p in temp) {
      if (p.product.codigo == product.codigo) {
        p.quantity += 1;
        found = true;
        break;
      }
    }
    if (!found) {
      temp.add(PreventaCart(product: product));
    }
    preVentaList = List<PreventaCart>.from(temp);
    calculateTotals(temp);
  }

  void increment(PreventaCart productCart) {
    productCart.quantity += 1;
    preVentaList = List<PreventaCart>.from(preVentaList);
    calculateTotals(preVentaList);
  }

  void decrement(PreventaCart productCart) {
    if (productCart.quantity > 1) {
      productCart.quantity -= 1;
      preVentaList = List<PreventaCart>.from(preVentaList);
      calculateTotals(preVentaList);
    }
  }

  void calculateTotals(List<PreventaCart> temp) {
    final total = temp.fold(
        0, (previousValue, element) => element.quantity + previousValue);
    totalItems = total;
    final totalCost = temp.fold(
        0.0,
        (previousValue, element) =>
            (element.quantity * element.product.preciocompra) + previousValue);
    totalPrice = totalCost;
    notifyListeners();
  }

  void deleteProduct(PreventaCart productCart) {
    preVentaList.remove(productCart);
    calculateTotals(preVentaList);
  }
}
