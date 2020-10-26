import 'package:arturo_bruna_app/state-management-project/presentation/common/alert_dialog.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/preventas/preventas_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/delivery_button.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/client_search_delegate.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/cliente_create.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/clientes_bloc.dart';

class ClientesScreen extends StatelessWidget {
  Future _showMyDialog(BuildContext context, Cliente client,
      ClientesBLoC clientsBLoC, PreSaleBLoC preSaleBLoC) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        content: Text(
          "¿Confirma agregar al cliente\n\"${client.nombre}\" en la Pre-Venta?",
          style: TextStyle(fontSize: 17.5),
          textAlign: TextAlign.center,
        ),
        actions: [
          FlatButton(
            child: Text(
              "Agregar",
              style: TextStyle(fontSize: 17.0),
            ),
            shape: StadiumBorder(),
            onPressed: () async {
              bool response = await preSaleBLoC.addClient(client);
              print(response);
              if (!response) {
                Navigator.of(context).pop();
                return showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialogPage(
                          oldContext: _,
                          content: Text(
                            "Ya existe un cliente en la Pre-Venta.\n¿Desea reemplazarlo?",
                            style: TextStyle(fontSize: 17.5),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            FlatButton(
                              child: Text(
                                "Reemplazar",
                                style: TextStyle(fontSize: 17.0),
                              ),
                              onPressed: () {
                                preSaleBLoC.updateClient(client);
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text(
                                "Cancelar",
                                style: TextStyle(fontSize: 17.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ));
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          FlatButton(
            shape: StadiumBorder(),
            child: Text(
              "Cancelar",
              style: TextStyle(fontSize: 17.0),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientsBloc = context.watch<ClientesBLoC>();
    final preSaleBloc = context.watch<PreSaleBLoC>();
    return Scaffold(
      backgroundColor: Colors.white70,
      floatingActionButton: FloatingActionButton(
        heroTag: "btnCreateClient",
        elevation: 25,
        backgroundColor: Colors.blue[700],
        child: Icon(
          Icons.add,
          size: 38,
        ),
        onPressed: () async {
          final response = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ClientCreate()));
          print('Respuesta del create $response');
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            color: Colors.white,
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: ClientSearchDelegate('Buscar cliente',
                      clientesBLoC: clientsBloc));
            },
            splashColor: Colors.transparent,
          )
        ],
        centerTitle: true,
        elevation: 6.0,
        title: Text(
          'Clientes',
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: clientsBloc.clientList.isNotEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                clientsBloc.loadClients();
              },
              color: Colors.white,
              backgroundColor: Colors.blue[900],
              child: OrientationBuilder(
                builder: (_, orientation) {
                  if (orientation == Orientation.landscape) {
                    return GridView.builder(
                        itemCount: clientsBloc.clientList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                        itemBuilder: (context, index) {
                          final client = clientsBloc.clientList[index];
                          return buildList(
                              context, index, client, clientsBloc.cardHeight,
                              () {
                            _showMyDialog(
                                context, client, clientsBloc, preSaleBloc);
                          });
                        });
                  }
                  return ListView.builder(
                      itemCount: clientsBloc.clientList.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final client = clientsBloc.clientList[index];
                        return buildList(
                            context, index, client, clientsBloc.cardHeight, () {
                          _showMyDialog(
                              context, client, clientsBloc, preSaleBloc);
                        });
                      });
                },
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black45,
              ),
            ),
    );
  }

  Widget buildList(BuildContext context, int index, Cliente client,
      double cardHeight, VoidCallback onTap) {
    if (client.numerocuotas == null) {
      cardHeight = 152;
    }
    return Card(
      margin: EdgeInsets.symmetric(vertical: 25, horizontal: 18),
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.white70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    client.nombre,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(client.direccion,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: .3,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      client.tipopago == 1
                          ? Icon(
                              Icons.monetization_on_rounded,
                              color: Colors.black,
                              size: 25,
                            )
                          : Icon(
                              Icons.payment,
                              color: Colors.black,
                              size: 25,
                            ),
                      SizedBox(
                        width: 5,
                      ),
                      client.tipopago == 1
                          ? Text('Efectivo',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  letterSpacing: .3))
                          : Text('Crédito',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  letterSpacing: .3)),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  client.tipopago == 1
                      ? SizedBox(
                          height: 25.0,
                        )
                      : client.numerocuotas != null
                          ? Row(
                              children: <Widget>[
                                Icon(
                                  Icons.timer,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('${client.numerocuotas} Días a pagar',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: .3,
                                        fontWeight: FontWeight.w400))
                              ],
                            )
                          : SizedBox(
                              height: 25.0,
                            ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: DeliveryButton(
                      text: "Añadir",
                      onTap: onTap,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
