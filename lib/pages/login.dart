import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/pages/login_body.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [Body()],
        ),
      ),
    );
  }
}
