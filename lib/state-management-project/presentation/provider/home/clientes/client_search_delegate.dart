import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/clientes_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';

class ClientSearchDelegate extends SearchDelegate<Cliente> {
  final ClientesBLoC clientesBLoC;
  @override
  final String searchFieldLabel;
  ClientSearchDelegate(this.searchFieldLabel, {this.clientesBLoC});

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
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().length == 0) {
      return Center(child: Text("Ingrese un valor válido"));
    }
    return FutureBuilder(
        future: clientesBLoC.getClientByNameRunEmail(query),
        builder: (_, AsyncSnapshot snapshot) {
          if (clientesBLoC.clientsByName.length != 0) {
            // Crear lista
            return _showClients(clientesBLoC.clientsByName);
          } else if (snapshot.connectionState == ConnectionState.done &&
              clientesBLoC.clientsByName.length == 0) {
            return Center(child: Text("No se encontró el cliente"));
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListTile(
      title: Text('Sugerencias'),
    );
  }

  Widget _showClients(List<Cliente> clientes) {
    return ListView.builder(
      itemBuilder: (BuildContext context, index) {
        final cliente = clientes[index];
        return ListTile(
          onTap: () {
            _showMyDialog(context, cliente);
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
      itemCount: clientes.length,
    );
  }

  Widget _buildAlertDialog(BuildContext context, Cliente cliente) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text('Cantidad'),
        content: Text('Contenido'),
        actions: [
          FlatButton(
            child: Text('Continuar'),
            onPressed: () {
              // print(productsBloc.cantidadProducto);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Center(child: Text('Aviso')),
        content: Text(
          '¿Desea agregar a ' + cliente.nombre + ' a la venta?',
          textAlign: TextAlign.center,
        ),
        actions: [
          FlatButton(
            child: Text('Agregar'),
            onPressed: () {
              // print(productsBloc.cantidadProducto);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }

  Future _showMyDialog(BuildContext context, Cliente cliente) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _buildAlertDialog(_, cliente),
    );
  }
}
