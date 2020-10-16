import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';

class SplashBLoC extends ChangeNotifier {
  final LocalRepositoryInterface localRepositoryInterface;
  final ApiRepositoryInterface apiRepositoryInterface;

  SplashBLoC({
    this.localRepositoryInterface,
    this.apiRepositoryInterface,
  });

  Future<bool> validateSession() async {
    final token = await localRepositoryInterface.getToken();
    // print('Token local: ' + token);
    if (token != null) {
      final user = await apiRepositoryInterface.getUserFromToken(token);
      await localRepositoryInterface.saveUser(user);
      return true;
    } else {
      return false;
    }
  }
}
