import 'package:arturo_bruna_app/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/domain/repository/local_storage_repository.dart';
import 'package:flutter/material.dart';

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
    await localRepositoryInterface.clearData();
  }
}
