import 'package:arturo_bruna_app/domain/repository/local_storage_repository.dart';
import 'package:flutter/material.dart';

import 'common/constants.dart';

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
      scaffoldBackgroundColor: Colors.blue,
    ));
  }

  void updateTheme(ThemeData theme) {
    currentTheme = theme;
    notifyListeners();
  }
}
