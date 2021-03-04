import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/product_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';

enum ProductsState {
  loading,
  initial,
}

class ProductosBLoC extends ChangeNotifier {
  final ApiRepositoryInterface apiRepositoryInterface;
  final LocalRepositoryInterface localRepositoryInterface;

  ProductosBLoC({this.apiRepositoryInterface, this.localRepositoryInterface});

  List<Producto> productList = <Producto>[];
  List<Producto> productsByName = <Producto>[];
  List<Producto> historial = [];
  var productsState = ProductsState.initial;
  int cantidadProducto = 1;

  Future<void> loadProducts() async {
    try {
      productsState = ProductsState.loading;
      notifyListeners();
      final result = await apiRepositoryInterface.getProducts();
      productList = result;
      print('LISTA PRODUCTOS $productList');
      productsState = ProductsState.initial;
      notifyListeners();
    } on ProductException catch (_) {
      print(_);
      productsState = ProductsState.initial;
      notifyListeners();
    }
    // notifyListeners();
  }

  Future<void> getProductsByNameCode(String name) async {
    try {
      // productsState = ProductsState.loading;
      // notifyListeners();
      final result = await apiRepositoryInterface.getProductByName(name);
      productsByName = result;
      // productsState = ProductsState.initial;
      // notifyListeners();
    } on ProductException catch (e) {
      print(e);
      // productsState = ProductsState.initial;
      // notifyListeners();
    }
  }
}
