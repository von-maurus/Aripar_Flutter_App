import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/domain/model/preventa_cart.dart';
import 'package:arturo_bruna_app/presentation/common/alert_dialog.dart';
import 'package:arturo_bruna_app/presentation/home/home_bloc.dart';
import 'package:arturo_bruna_app/presentation/home/preventas/preventas_bloc.dart';

class CheckoutLandscapeView extends StatelessWidget {
  const CheckoutLandscapeView({
    Key key,
    @required this.bloc,
    @required this.formatter,
    @required this.homeBloc,
  }) : super(key: key);

  final PreSaleBLoC bloc;
  final NumberFormat formatter;
  final HomeBLoC homeBloc;

  ListTile buildCheckoutDetail(PreSaleCart preSaleCart) {
    return ListTile(
      title: Text(
        preSaleCart.product.nombre + ' x' + preSaleCart.quantity.toString(),
        maxLines: 1,
        style: TextStyle(fontSize: 16.5),
      ),
      trailing: Text(
        '\$' + formatter.format(preSaleCart.precioLinea),
        style: TextStyle(
          fontSize: 18.5,
        ),
      ),
    );
  }

  Future<void> buildResponseDialog(BuildContext context, dynamic response) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        title: Center(
          child: Text("Pre-Venta"),
        ),
        content: Text(
          '$response',
          style: TextStyle(fontSize: 17.5),
          textAlign: TextAlign.center,
        ),
        actions: [
          FlatButton(
            child: Text(
              "Aceptar",
              style: TextStyle(fontSize: 17.0),
            ),
            shape: StadiumBorder(),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            color: Colors.blue[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
              ),
            ),
            margin: EdgeInsets.zero,
            elevation: 30,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cliente",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          bloc.client.nombre == null
                              ? 'No Seleccionado'
                              : bloc.client.nombre + '\n' + bloc.client.rut,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Método de Pago",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          bloc.payType == null
                              ? 'No Seleccionado'
                              : bloc.payType == 1
                                  ? 'Efectivo'
                                  : 'Crédito\n${bloc.numDias} días a pagar',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '\$${formatter.format(bloc.totalPrice)}',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final preSaleCart = bloc.preSaleList[index];
                    return buildCheckoutDetail(preSaleCart);
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 0,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey,
                    thickness: 1.5,
                  ),
                  itemCount: bloc.preSaleList.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: () async {
                      if (bloc.client.id != null) {
                        return showDialog(
                          context: context,
                          builder: (_) => AlertDialogPage(
                            oldContext: _,
                            title: Center(
                                child: Text(
                              "Aviso",
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            content: Text(
                              "Se creará una Pre-Venta.\n¿Desea continuar?...",
                              style: TextStyle(fontSize: 18.0),
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              FlatButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  //Esperar respuesta
                                  final response = await bloc.checkOut();
                                  //Mostrar AlertDialog con respuesta
                                  return buildResponseDialog(context, response);
                                },
                                child: Text(
                                  "Aceptar",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      return showDialog(
                        context: context,
                        builder: (_) => AlertDialogPage(
                          oldContext: _,
                          title: Center(
                              child: Text(
                            "Alerta",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          content: Text(
                            "Debe seleccionar un cliente",
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  homeBloc.updateIndexSelected(1);
                                },
                                child: Text(
                                  "Aceptar",
                                  style: TextStyle(fontSize: 18.0),
                                ))
                          ],
                        ),
                      );
                    },
                    shape: StadiumBorder(),
                    child: Text(
                      "Confirmar Pre-venta",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.025,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
