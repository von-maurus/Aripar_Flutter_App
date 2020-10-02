import 'dart:io';
import 'package:flutter/material.dart';

//TODO: Mostrar opciones de configuracion (por el momento solo editar datos)
//TODO: Actualizar datos del usuario, imagen de perfil y contraseña

class UserProfilePage extends StatefulWidget {
  final Size size;
  const UserProfilePage({Key key, @required this.size}) : super(key: key);
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
        elevation: 5,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                        height: widget.size.height * 0.2,
                        margin: EdgeInsets.only(top: widget.size.height * 0.07),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70.0),
                          child: Image.asset(
                            "assets/images/james.png",
                            fit: BoxFit.cover,
                            width: 140.0,
                            height: 150.0,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Text(
                      "Mauricio Sánchez R.",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Text(
                      "Vendedor Arippar",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                    padding:
                                        EdgeInsets.only(top: 15, bottom: 5),
                                    child: Text("Registrado desde",
                                        style:
                                            TextStyle(color: Colors.black54))),
                                Container(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: Text("28-09-2020",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16))),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 5),
                                    child: Text("Ordenes emitidas",
                                        style:
                                            TextStyle(color: Colors.black54))),
                                Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text("25",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    _UserInfo()
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Información",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                      child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text("Email"),
                        subtitle: Text("sudeptech@gmail.com"),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text("Contacto"),
                        subtitle: Text("+569 88888888"),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
