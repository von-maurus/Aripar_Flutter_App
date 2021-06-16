import 'dart:async';
import 'package:arturo_bruna_app/domain/exception/auth_exception.dart';
import 'package:arturo_bruna_app/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/presentation/home/home_screen.dart';
import 'package:arturo_bruna_app/presentation/login/login.dart';
import 'package:flutter/material.dart';

class SplashBLoC extends ChangeNotifier {
  final LocalRepositoryInterface localRepositoryInterface;
  final ApiRepositoryInterface apiRepositoryInterface;
  bool isTimeoutException = false;
  String errorMessage;

  SplashBLoC({
    this.localRepositoryInterface,
    this.apiRepositoryInterface,
  });

  void init(BuildContext context, GlobalKey<ScaffoldMessengerState> scaffoldKey) async {
    final result = await validateSession(scaffoldKey);
    await Future.delayed(Duration(milliseconds: 1100));
    if (result) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage.init(context),
        ),
      );
    } else {
      if (!isTimeoutException) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginPage.init(context),
          ),
        );
      }
    }
  }

  Future<bool> validateSession(GlobalKey<ScaffoldMessengerState> scaffoldKey) async {
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
