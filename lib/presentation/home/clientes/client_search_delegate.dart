import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/domain/model/cliente.dart';
import 'package:arturo_bruna_app/presentation/common/alert_dialog.dart';
import 'package:arturo_bruna_app/presentation/home/clientes/clientes_bloc.dart';
import 'package:arturo_bruna_app/presentation/home/preventas/preventas_bloc.dart';

class ClientSearchDelegate extends SearchDelegate<Cliente> {
  final ClientesBLoC clientesBLoC;
  final PreSaleBLoC preSaleBLoC;

  @override
  final String searchFieldLabel;

  ClientSearchDelegate(this.searchFieldLabel,
      {this.clientesBLoC, this.preSaleBLoC});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        splashColor: Colors.transparent,
        onPressed: () => this.query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
      splashColor: Colors.transparent,
      onPressed: () async {
        FocusScope.of(context).unfocus();
        await Future.delayed(Duration(milliseconds: 100));
        this.close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().length == 0) {
      return Center(
          child: Text(
        "Ingrese un cliente",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
      ));
    }
    return FutureBuilder(
        future: clientesBLoC.getClientByNameRunEmail(query),
        builder: (_, AsyncSnapshot snapshot) {
          if (clientesBLoC.clientsByName.length != 0) {
            // Crear lista
            return _showClients(clientesBLoC.clientsByName);
          } else if (snapshot.connectionState == ConnectionState.done &&
              clientesBLoC.clientsByName.length == 0) {
            return Center(
              child: Text(
                "No se encontró el cliente",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 8,
              ),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _showClients(clientesBLoC.historial);
  }

  Widget _showClients(List<Cliente> clientes) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: clientes.length,
      itemBuilder: (BuildContext context, index) {
        final cliente = clientes[index];
        return ListTile(
          onTap: () async {
            _showMyDialog(context, cliente, clientesBLoC, preSaleBLoC);
          },
          leading: cliente.tipopago == 1
              ? Icon(
                  Icons.monetization_on,
                  color: Colors.green,
                )
              : Icon(
                  Icons.credit_card,
                  color: Colors.blue,
                ),
          title: Text(
            cliente.nombre,
            maxLines: 1,
            style: TextStyle(fontSize: 15),
          ),
          subtitle: Text(
            'RUN:' + cliente.rut,
            maxLines: 1,
            style: TextStyle(fontSize: 11.5),
          ),
        );
      },
    );
  }

  Future _showMyDialog(BuildContext context, Cliente cliente,
      ClientesBLoC clientsBLoC, PreSaleBLoC preSaleBLoC) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        content: Text(
          "\n¿Confirma agregar al cliente\n\"${cliente.nombre}\" \nen la Pre-Venta?",
          style: TextStyle(fontSize: 17.5),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(StadiumBorder()),
            ),
            child: Text(
              "Agregar",
              style: TextStyle(fontSize: 17.0),
            ),
            onPressed: () async {
              bool response = await preSaleBLoC.addClient(cliente);
              print(response);
              if (!response) {
                Navigator.of(context).pop();
                return showReplaceClientDialog(context, preSaleBLoC, cliente);
              } else {
                Navigator.of(context).pop();
                this.close(context, cliente);
              }
            },
          ),
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(StadiumBorder()),
            ),
            child: Text(
              "Cancelar",
              style: TextStyle(fontSize: 17.0),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              this.close(context, cliente);
            },
          ),
        ],
      ),
    );
  }

  Future<void> showReplaceClientDialog(
      BuildContext context, PreSaleBLoC preSaleBLoC, Cliente client) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        title: Center(
          child: Text(
            "Advertencia",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Text(
          "Ya existe un cliente en la \nPre-Venta.\n¿Desea reemplazarlo?",
          style: TextStyle(fontSize: 17.5),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            child: Text(
              "Reemplazar",
              style: TextStyle(fontSize: 17.0),
            ),
            onPressed: () {
              preSaleBLoC.updateClient(client);
              Navigator.of(context).pop();
              this.close(context, client);
            },
          ),
          TextButton(
            child: Text(
              "Cancelar",
              style: TextStyle(fontSize: 17.0),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              this.close(context, client);
            },
          ),
        ],
      ),
    );
  }
}
