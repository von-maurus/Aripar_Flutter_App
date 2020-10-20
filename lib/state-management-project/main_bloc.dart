import 'package:arturo_bruna_app/state-management-project/presentation/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';

class MainBLoC extends ChangeNotifier {
  ThemeData currentTheme;

  final LocalRepositoryInterface localRepositoryInterface;

  MainBLoC({
    this.localRepositoryInterface,
  });

  void loadTheme() async {
    // final isDark = await localRepositoryInterface.isDarkMode() ?? false;
    updateTheme(ThemeData(
      primaryColor: kPrimaryColor2,
      scaffoldBackgroundColor: Colors.grey.shade100,
    ));
  }

  void updateTheme(ThemeData theme) {
    currentTheme = theme;
    notifyListeners();
  }
}
