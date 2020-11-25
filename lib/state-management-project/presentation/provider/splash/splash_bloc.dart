import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/auth_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';

class SplashBLoC extends ChangeNotifier {
  final LocalRepositoryInterface localRepositoryInterface;
  final ApiRepositoryInterface apiRepositoryInterface;

  SplashBLoC({
    this.localRepositoryInterface,
    this.apiRepositoryInterface,
  });

  Future<bool> validateSession(GlobalKey<ScaffoldState> scaffoldKey) async {
    final token = await localRepositoryInterface.getToken();
    if (token != null) {
      try {
        final user = await apiRepositoryInterface.getUserFromToken(token);
        await localRepositoryInterface.saveUser(user);
        return true;
      } on AuthException catch (e) {
        print(e);
        return false;
      } on Exception catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }
}
