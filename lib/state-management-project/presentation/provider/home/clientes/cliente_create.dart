import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/state-management-project/presentation/common/size_config.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/rounded_button.dart';
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
      body: _CustomForm(
        clientsBLoC: clientsBloc,
        size: size,
        maskFormatter: clientsBloc.maskFormatter,
        scaffoldKey: _scaffoldKey,
      ),
    );
  }
}

class _CustomForm extends StatelessWidget {
  final ClientesBLoC clientsBLoC;
  final Size size;
  final maskFormatter;
  final scaffoldKey;

  const _CustomForm(
      {Key key,
      this.clientsBLoC,
      this.size,
      this.maskFormatter,
      this.scaffoldKey})
      : super(key: key);

  void onSubmit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final result = await clientsBLoC.submitData();
    if (result) {
      Navigator.of(context).pop();
    } else {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 900),
          content: Text('No se logró crear al cliente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: size.height,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) {
                      clientsBLoC.changeName(value);
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Nombre",
                      errorText: clientsBLoC.nombre.error,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    inputFormatters: [maskFormatter],
                    onChanged: (String value) {
                      if (clientsBLoC.maskFormatter.getUnmaskedText().length <
                          8) {
                        clientsBLoC.maskFormatter
                            .updateMask(mask: '#.###.###-#');
                      } else {
                        clientsBLoC.maskFormatter
                            .updateMask(mask: '##.###.###-#');
                      }
                      clientsBLoC.changeRUN(value);
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_search_rounded),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "RUT",
                      hintText: "90.000.000-0",
                      errorText: clientsBLoC.rut.error,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.alternate_email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Correo",
                      hintText: "example@mail.com",
                      errorText: clientsBLoC.correo.error,
                    ),
                    onChanged: (String value) {
                      clientsBLoC.changeEmail(value);
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on_rounded),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Dirección",
                      errorText: clientsBLoC.direccion.error,
                    ),
                    onChanged: (String value) {
                      clientsBLoC.changeAddress(value);
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Teléfono",
                      errorText: clientsBLoC.fono.error,
                    ),
                    onChanged: (String value) {
                      clientsBLoC.changePhone(value);
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: ListTile(
                          title: Text('Efectivo',
                              style: TextStyle(fontSize: 18.0)),
                          leading: Radio(
                            value: "1",
                            groupValue: clientsBLoC.tipoPago.value,
                            onChanged: (value) {
                              clientsBLoC.changePayType(value);
                            },
                          ),
                          onTap: () {
                            clientsBLoC.changePayType("1");
                          },
                        ),
                      ),
                      Flexible(
                        child: ListTile(
                          title:
                              Text('Crédito', style: TextStyle(fontSize: 18.0)),
                          leading: Radio(
                            value: "2",
                            groupValue: clientsBLoC.tipoPago.value,
                            onChanged: (value) {
                              clientsBLoC.changePayType(value);
                            },
                          ),
                          onTap: () {
                            clientsBLoC.changePayType("2");
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  clientsBLoC.tipoPago.value == "1"
                      ? Container()
                      : TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.timelapse),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Días a pagar",
                            errorText: clientsBLoC.numCuotas.error,
                          ),
                          onChanged: (String value) {
                            clientsBLoC.changeNumCuotas(value);
                          },
                        ),
                  SizedBox(
                    height: 28,
                  ),
                  RoundedButton(
                    size: size,
                    onPressed: () {
                      if (!clientsBLoC.isValid) {
                        clientsBLoC.changeName(clientsBLoC.nombre.value);
                        clientsBLoC.changeRUN(clientsBLoC.rut.value);
                        clientsBLoC.changeEmail(clientsBLoC.correo.value);
                        clientsBLoC.changeAddress(clientsBLoC.direccion.value);
                        clientsBLoC.changePhone(clientsBLoC.fono.value);
                        clientsBLoC
                            .changeNumCuotas(clientsBLoC.numCuotas.value);
                      } else {
                        onSubmit(context);
                      }
                    },
                    buttonColor: Colors.green[600],
                    buttonText: "Agregar",
                  ),
                ],
              ),
            ),
          ),
        ),
        if (clientsBLoC.clientsState == ClientsState.loading)
          Container(
            color: Colors.black45,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
