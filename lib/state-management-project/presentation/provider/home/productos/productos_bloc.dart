import 'package:arturo_bruna_app/state-management-project/domain/exception/product_exception.dart';
import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
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
  var productsState = ProductsState.initial;

  Future<void> loadProducts() async {
    try {
      productsState = ProductsState.loading;
      notifyListeners();
      final result = await apiRepositoryInterface.getProducts();
      productList = result;
      productsState = ProductsState.initial;
      notifyListeners();
    } on ProductException catch (_) {
      productsState = ProductsState.initial;
      notifyListeners();
    }
    // print('LISTA DE PRODUCTOS ');
    // print(productList);
    notifyListeners();
  }
}
