import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/pages/login_body.dart';

//TODO: Iniciar sesión.
//TODO: Crear y checkear token localmente para mantener sesión.
//TODO: Crear datos locales del usuario.
//TODO: Cerrar sesión.

//Guardar token con localstorage
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
