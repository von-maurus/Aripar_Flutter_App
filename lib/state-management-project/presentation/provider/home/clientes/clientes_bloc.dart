import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/client_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';

enum ClientsState {
  loading,
  initial,
}

class ClientesBLoC extends ChangeNotifier {
  final ApiRepositoryInterface apiRepositoryInterface;
  final LocalRepositoryInterface localRepositoryInterface;

  ClientesBLoC({this.apiRepositoryInterface, this.localRepositoryInterface});

  List<Cliente> clientList = <Cliente>[];
  List<Cliente> clientsByName = <Cliente>[];
  var clientsState = ClientsState.initial;
  double cardHeight = 180;

  void loadClients() async {
    try {
      clientsState = ClientsState.loading;
      notifyListeners();
      final result = await apiRepositoryInterface.getClientes();
      clientList = result;
      clientsState = ClientsState.initial;
      notifyListeners();
    } on ClientException catch (_) {
      clientsState = ClientsState.initial;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> getClientByNameRunEmail(String query) async {
    try {
      // productsState = ProductsState.loading;
      // notifyListeners();
      final result =
          await apiRepositoryInterface.getClientByNameRunEmail(query);
      clientsByName = result;
      // productsState = ProductsState.initial;
      // notifyListeners();
    } on ClientException catch (e) {
      print(e);
      // productsState = ProductsState.initial;
      // notifyListeners();
    }
  }

  void insertClient() async {
    try {} on ClientException catch (_) {}
    notifyListeners();
  }
}
