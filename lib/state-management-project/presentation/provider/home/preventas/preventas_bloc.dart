import 'package:arturo_bruna_app/state-management-project/domain/exception/preventa_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/preventa_cart.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum PreSaleState {
  loading,
  stable,
}

class PreSaleBLoC extends ChangeNotifier {
  final ApiRepositoryInterface apiRepositoryInterface;
  final LocalRepositoryInterface localRepositoryInterface;

  int payType;
  List<PreSaleCart> preSaleList = <PreSaleCart>[];
  Cliente client = new Cliente();
  int totalItems = 0;
  int totalPrice = 0;
  int productsCount = 0;
  var preSaleState = PreSaleState.stable;
  int diasCuota;
  MaskTextInputFormatter maskTextInputFormatter =
      new MaskTextInputFormatter(mask: '##.###.###-#');
  PreSaleBLoC({this.apiRepositoryInterface, this.localRepositoryInterface});

  void changePayType(int clientPayType, int dias) {
    if (clientPayType != 1) {
      payType = clientPayType;
      diasCuota = dias;
      notifyListeners();
    } else {
      payType = clientPayType;
      notifyListeners();
    }
  }

  void cleanSalesCart() {
    preSaleList.clear();
    calculateTotals(preSaleList);
    client = new Cliente();
    totalItems = 0;
    totalPrice = 0;
    productsCount = 0;
    diasCuota = 7;
    payType = null;
    notifyListeners();
  }

  void add(Producto product, int quantity) {
    final tempList = List<PreSaleCart>.from(preSaleList);
    bool found = false;
    for (PreSaleCart p in tempList) {
      if (p.product.id == product.id) {
        p.quantity += quantity;
        p.precioLinea += quantity * p.product.precioVentaFinal;
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
        precioLinea: product.precioVentaFinal * quantity,
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
      if (newClient.numerocuotas == null) {
        diasCuota = 7;
      } else {
        diasCuota = newClient.numerocuotas;
      }
      client.rut = maskTextInputFormatter.maskText(client.rut);
      notifyListeners();
      return true;
    }
  }

  void updateClient(Cliente newClient) {
    client = newClient;
    payType = newClient.tipopago;
    diasCuota = newClient.numerocuotas;
    client.rut = maskTextInputFormatter.maskText(client.rut);
    notifyListeners();
  }

  void increment(PreSaleCart productCart) {
    if (productCart.quantity < productCart.product.stock) {
      productCart.quantity += 1;
      productCart.precioLinea += productCart.product.precioVentaFinal;
      notifyListeners();
      preSaleList = List<PreSaleCart>.from(preSaleList);
      calculateTotals(preSaleList);
    }
  }

  void decrement(PreSaleCart productCart) {
    if (productCart.quantity > 1) {
      productCart.quantity -= 1;
      productCart.precioLinea -= productCart.product.precioVentaFinal;
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
            (element.quantity * element.product.precioVentaFinal) +
            previousValue);
    totalPrice = totalCost;
    notifyListeners();
  }

  void deleteProduct(PreSaleCart productCart) {
    productsCount -= 1;
    notifyListeners();
    preSaleList.remove(productCart);
    calculateTotals(preSaleList);
  }

  Future<dynamic> checkOut() async {
    preSaleState = PreSaleState.loading;
    notifyListeners();
    if (client.id == null) {
      preSaleState = PreSaleState.stable;
      notifyListeners();
      return 'Por favor, ingrese un cliente a su venta.';
    }
    try {
      //Api request
      final token = await localRepositoryInterface.getToken();
      final response = await apiRepositoryInterface.createPreSale(
          preSaleList, client.id, payType, totalPrice, token, diasCuota);
      preSaleState = PreSaleState.stable;
      notifyListeners();
      return response;
    } on PreSaleException catch (e) {
      print(e);
      preSaleState = PreSaleState.stable;
      notifyListeners();
      return 'Ocurrio un error: $e';
    } on Exception catch (e) {
      print(e);
      preSaleState = PreSaleState.stable;
      notifyListeners();
      return 'Ocurrio un error: $e';
    }
  }
}
