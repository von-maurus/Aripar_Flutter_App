import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/user.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';

class HomeBLoC extends ChangeNotifier {
  final LocalRepositoryInterface localRepositoryInterface;
  final ApiRepositoryInterface apiRepositoryInterface;

  HomeBLoC({this.localRepositoryInterface, this.apiRepositoryInterface});

  Usuario usuario;
  int indexSelected = 0;

  void loadUser() async {
    usuario = await localRepositoryInterface.getUser();
    notifyListeners();
  }

  void updateIndexSelected(int index) {
    indexSelected = index;
    notifyListeners();
  }
}
