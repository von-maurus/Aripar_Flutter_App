import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/delivery_button.dart';
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
        elevation: 10,
        backgroundColor: Colors.orange[800],
        child: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {},
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 6.0,
        title: Text(
          'Clientes',
          style: TextStyle(letterSpacing: 1.0, fontSize: 25.0),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: clientsBloc.clientList.isNotEmpty
          ? SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.789,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 70),
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: ListView.builder(
                          itemCount: clientsBloc.clientList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final client = clientsBloc.clientList[index];
                            return buildList(
                                context, index, client, clientsBloc.cardHeight);
                          }),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 18,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Material(
                              elevation: 15.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: TextField(
                                // controller: TextEditingController(text: locations[0]),
                                cursorColor: Theme.of(context).primaryColor,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                decoration: InputDecoration(
                                    hintText:
                                        "Buscar Cliente. Por Nombre o RUT",
                                    hintStyle: TextStyle(
                                        color: Colors.black38, fontSize: 16),
                                    prefixIcon: Material(
                                      elevation: 0.0,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      child: Icon(Icons.search),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 13)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      width: double.infinity,
      height: cardHeight,
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
                      color: Color(0xfff29a94),
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
                    Icon(
                      Icons.payment,
                      color: Color(0xfff29a94),
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
                client.numerocuotas != null
                    ? Row(
                        children: <Widget>[
                          Icon(
                            Icons.timer,
                            color: Color(0xfff29a94),
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
                  child: DeliveryButton(
                    onTap: () {
                      print("Añadir cliente");
                    },
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.5, horizontal: 142.0),
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
