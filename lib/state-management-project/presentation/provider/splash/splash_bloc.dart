import 'dart:async';

import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/auth_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';

class SplashBLoC extends ChangeNotifier {
  final LocalRepositoryInterface localRepositoryInterface;
  final ApiRepositoryInterface apiRepositoryInterface;
  bool isTimeoutException = false;
  String errorMessage;

  SplashBLoC({
    this.localRepositoryInterface,
    this.apiRepositoryInterface,
  });

  Future<bool> validateSession(GlobalKey<ScaffoldState> scaffoldKey) async {
    final token = await localRepositoryInterface.getToken();
    isTimeoutException = false;
    notifyListeners();
    if (token != null) {
      try {
        final user = await apiRepositoryInterface.getUserFromToken(token);
        await localRepositoryInterface.saveUser(user);
        return true;
      } on AuthException catch (e) {
        print('AuthException (invalid token): $e');
        errorMessage = 'Su sesión a expirado.';
        notifyListeners();
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 2000),
            content: Text('Ha ocurrido un error: $errorMessage'),
          ),
        );
        return false;
      } on TimeoutException catch (e) {
        errorMessage = e.message;
        isTimeoutException = true;
        notifyListeners();
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 2200),
            content: Text('Ha ocurrido un error: $errorMessage'),
          ),
        );
        print('TimeoutException: ${e.message}');
        return false;
      } on Exception catch (e) {
        errorMessage = 'Ha ocurrido un error inesperado.';
        notifyListeners();
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 2000),
            content: Text('$errorMessage'),
          ),
        );
        print('Any other Exception: $e');
        return false;
      }
    } else {
      return false;
    }
  }
}
