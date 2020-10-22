import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';

class ProfileBLoC extends ChangeNotifier {
  final LocalRepositoryInterface localRepositoryInterface;
  final ApiRepositoryInterface apiRepositoryInterface;

  ProfileBLoC({this.localRepositoryInterface, this.apiRepositoryInterface});
  bool isDark = false;
  final switchNotifier = ValueNotifier<bool>(false);

  void loadTheme() async {
    isDark = await localRepositoryInterface.getTheme() ?? false;
    switchNotifier.value = isDark;
    notifyListeners();
  }

  void updateTheme(bool isDarkValue) {
    localRepositoryInterface.saveTheme(isDarkValue);
    isDark = isDarkValue;
    //notifyListeners();
    switchNotifier.value = isDark;
  }

  Future<void> logOut() async {
    final token = await localRepositoryInterface.getToken();
    // print('TOKEN ACTUAL' + token);
    await apiRepositoryInterface.logout(token);
    await localRepositoryInterface.clearData();
  }
}
