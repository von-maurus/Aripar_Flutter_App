import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arturo_bruna_app/state-management-project/main_provider.dart';

void main() => runApp(AriApp());

class AriApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainProvider(),
    );
  }
}
