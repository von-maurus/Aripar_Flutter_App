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

  LoginBLoC({
    this.localRepositoryInterface,
    this.apiRepositoryInterface,
  });

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  var loginState = LoginState.initial;

  Future<bool> login() async {
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
        loginState = LoginState.initial;
        notifyListeners();
        return false;
      }
    } else {
      return false;
    }
  }
}
