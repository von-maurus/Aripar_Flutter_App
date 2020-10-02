import 'package:flutter/cupertino.dart';
import 'package:arturo_bruna_app/pages/home.dart';
import 'package:arturo_bruna_app/pages/loading.dart';
import 'package:arturo_bruna_app/pages/login.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'login': (_) => LoginPage(),
  'home': (_) => HomePage(),
  'loading': (_) => LoadingPage(),
};
