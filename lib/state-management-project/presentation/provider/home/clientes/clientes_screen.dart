import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/delivery_button.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/client_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/clientes_bloc.dart';

class ClientesScreen extends StatelessWidget {
  ClientesScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientesBLoC(
          apiRepositoryInterface: context.read<ApiRepositoryInterface>())
        ..loadClients(),
      builder: (_, __) => ClientesScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientsBloc = context.watch<ClientesBLoC>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        backgroundColor: Colors.blue[900],
        child: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {},
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
          style: TextStyle(letterSpacing: 1.0, fontSize: 25.0),
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
              child: ListView.builder(
                  itemCount: clientsBloc.clientList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final client = clientsBloc.clientList[index];
                    return buildList(
                        context, index, client, clientsBloc.cardHeight);
                  }),
            )
          : const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black45,
              ),
            ),
    );
  }

  Widget buildList(
      BuildContext context, int index, Cliente client, double cardHeight) {
    if (client.numerocuotas == null) {
      cardHeight = 152;
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.grey.shade300,
      ),
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
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
                    Text(client.direccion,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: .3,
                            fontWeight: FontWeight.w400)),
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
                    ? SizedBox.shrink()
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
                        : SizedBox.shrink(),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: DeliveryButton(
                    text: "Añadir",
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
