import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/state-management-project/presentation/common/size_config.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/create_custom_form.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/clientes_bloc.dart';

class ClientCreate extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final clientsBloc = context.watch<ClientesBLoC>();
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 6.0,
        title: Text(
          'Crear nuevo cliente',
          style: TextStyle(letterSpacing: 1.0, fontSize: 25.0),
        ),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Platform.isAndroid
              ? Icon(
                  Icons.arrow_back,
                  size: 30.0,
                  color: Colors.white,
                )
              : Icon(
                  Icons.arrow_back_ios,
                  size: 30.0,
                  color: Colors.white,
                ),
          onPressed: () async {
            clientsBloc.clearFields();
            FocusScope.of(context).unfocus();
            await Future.delayed(Duration(milliseconds: 100));
            Navigator.of(context).pop();
          },
        ),
      ),
      body: CustomForm(
        scaffoldKey: _scaffoldKey,
        size: size,
        clientsBLoC: clientsBloc,
        maskFormatter: clientsBloc.maskFormatter,
      ),
    );
  }
}
