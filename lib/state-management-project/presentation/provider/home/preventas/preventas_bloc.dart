import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/preventa_cart.dart';

class PreSaleBLoC extends ChangeNotifier {
  final ApiRepositoryInterface apiRepositoryInterface;
  int payType;
  List<PreSaleCart> preSaleList = <PreSaleCart>[];
  Cliente client = new Cliente();
  int totalItems = 0;
  int totalPrice = 0;
  int productsCount = 0;

  PreSaleBLoC({this.apiRepositoryInterface});

  void add(Producto product, int quantity) {
    print(quantity);
    final tempList = List<PreSaleCart>.from(preSaleList);
    bool found = false;
    for (PreSaleCart p in tempList) {
      if (p.product.id == product.id) {
        p.quantity += quantity;
        p.precioLinea += quantity * p.product.precioventa;
        found = true;
        break;
      }
    }
    if (!found) {
      productsCount = productsCount + 1;
      notifyListeners();
      tempList.add(PreSaleCart(
        product: product,
        quantity: quantity,
        precioLinea: product.precioventa * quantity,
      ));
    }
    preSaleList = List<PreSaleCart>.from(tempList);
    calculateTotals(tempList);
  }

  Future<bool> addClient(Cliente newClient) async {
    //Añadir un nuevo cliente
    if (client.id != null) {
      return false;
    } else {
      client = newClient;
      payType = newClient.tipopago;
      notifyListeners();
      return true;
    }
  }

  void updateClient(Cliente newClient) {
    client = newClient;
    payType = newClient.tipopago;
    notifyListeners();
  }

  void increment(PreSaleCart productCart) {
    if (productCart.quantity < productCart.product.stock) {
      productCart.quantity += 1;
      productCart.precioLinea += productCart.product.precioventa;
      notifyListeners();
      preSaleList = List<PreSaleCart>.from(preSaleList);
      calculateTotals(preSaleList);
    }
  }

  void decrement(PreSaleCart productCart) {
    if (productCart.quantity > 1) {
      productCart.quantity -= 1;
      productCart.precioLinea -= productCart.product.precioventa;
      preSaleList = List<PreSaleCart>.from(preSaleList);
      calculateTotals(preSaleList);
    }
  }

  void calculateTotals(List<PreSaleCart> temp) {
    final total = temp.fold(
        0, (previousValue, element) => element.quantity + previousValue);
    totalItems = total;
    final totalCost = temp.fold(
        0,
        (previousValue, element) =>
            (element.quantity * element.product.precioventa) + previousValue);
    totalPrice = totalCost;
    notifyListeners();
  }

  void deleteProduct(PreSaleCart productCart) {
    productsCount = productsCount - 1;
    notifyListeners();
    preSaleList.remove(productCart);
    calculateTotals(preSaleList);
  }
}
