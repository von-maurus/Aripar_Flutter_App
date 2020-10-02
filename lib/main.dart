import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/routes.dart';
import 'package:arturo_bruna_app/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arturo Bruna App',
      routes: appRoutes,
      initialRoute: 'home',
      theme: ThemeData(
        primaryColor: kPrimaryColor2,
        scaffoldBackgroundColor: kScaffoldBackgroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
