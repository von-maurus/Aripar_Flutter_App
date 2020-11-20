import 'dart:async';
import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/state-management-project/domain/exception/auth_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/request/login_request.dart';

enum LoginState {
  loading,
  initial,
}

class LoginBLoC extends ChangeNotifier {
  final LocalRepositoryInterface localRepositoryInterface;
  final ApiRepositoryInterface apiRepositoryInterface;
  bool isObscure = true;

  LoginBLoC({
    this.localRepositoryInterface,
    this.apiRepositoryInterface,
  });

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  var loginState = LoginState.initial;

  Future<bool> login(GlobalKey<ScaffoldState> scaffoldKey) async {
    final email = emailTextController.text;
    final password = passwordTextController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        loginState = LoginState.loading;
        notifyListeners();
        final loginResponse = await apiRepositoryInterface.login(
          LoginRequest(email, password),
        );
        await localRepositoryInterface.saveToken(loginResponse.token);
        await localRepositoryInterface.saveUser(loginResponse.usuario);
        loginState = LoginState.initial;
        notifyListeners();
        return true;
      } on AuthException catch (_) {
        print(_);
        loginState = LoginState.initial;
        notifyListeners();
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 1200),
            content: Text('Email o Contraseña incorrectos.'),
          ),
        );
        return false;
      } on Exception catch (e) {
        print(e);
        loginState = LoginState.initial;
        notifyListeners();
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 1200),
            content: Text('Error de conexión, intentelo nuevamente. $e'),
          ),
        );
        return false;
      }
    } else {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 1200),
          content: Text('Las credenciales son incorrectas'),
        ),
      );
      return false;
    }
  }

  void showHidePassword() {
    isObscure = !isObscure;
    notifyListeners();
  }
}
