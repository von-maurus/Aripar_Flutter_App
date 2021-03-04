import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/preventa_cart.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/home_screen.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/alert_dialog.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/productos/productos_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/preventas/preventas_bloc.dart';

class CheckoutPortraitView extends StatelessWidget {
  const CheckoutPortraitView({
    Key key,
    @required this.bloc,
    @required this.formatter,
    @required this.homeBloc,
    // @required this.productBloc,
  }) : super(key: key);

  final PreSaleBLoC bloc;
  final NumberFormat formatter;
  final HomeBLoC homeBloc;
  // final ProductosBLoC productBloc;

  Future<void> buildResponseDialog(
      BuildContext context, dynamic response, ProductosBLoC productBloc) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        title: Center(
          child: Text("Pre-Venta"),
        ),
        //TODO: Mejorar la repuesta de stock insuficiente, retornando la lista de productos rechazados (ListViewBuilder)
        content: bloc.isStockError
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "$response",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  )
                ],
              )
            : Container(
                child: Text(
                  "$response",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
        actions: [
          FlatButton(
            child: Text(
              "Aceptar",
              style: TextStyle(fontSize: 17.0),
            ),
            splashColor: Colors.grey,
            shape: StadiumBorder(),
            onPressed: () async {
              if (bloc.isAnyError || bloc.isStockError) {
                //Permanecer en la vista
                Navigator.of(context).pop();
              } else {
                //Vaciar carrito de compras, redirigir a pantalla Productos y recargar lista de productos
                bloc.cleanSalesCart();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage.init(context),
                  ),
                  (route) => false,
                );
              }
            },
          ),
          SizedBox(
            width: 85.0,
          ),
        ],
      ),
    );
  }

  Future buildEditDialog(BuildContext context, PreSaleBLoC bloc) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.money_outlined,
                        size: 35.0,
                        color: Colors.blue[900],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Efectivo',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  leading: Radio(
                    value: 1,
                    groupValue: bloc.payType,
                    onChanged: (value) {
                      setState(() => bloc.changePayType(value, 1));
                    },
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.credit_card_rounded,
                        size: 35.0,
                        color: Colors.blue[900],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Crédito',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  leading: Radio(
                    value: 2,
                    groupValue: bloc.payType,
                    onChanged: (value) {
                      setState(() => bloc.changePayType(value, 1));
                    },
                  ),
                ),
                bloc.payType == 1
                    ? SizedBox.shrink()
                    : SizedBox(
                        child: Container(
                          color: Colors.white24,
                          margin: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      '7 días',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Radio(
                                  value: 1,
                                  groupValue: bloc.diasCuota,
                                  onChanged: (value) {
                                    setState(() => bloc.changePayType(
                                        bloc.payType, value));
                                  },
                                ),
                              ),
                              ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      '15 días',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Radio(
                                  value: 2,
                                  groupValue: bloc.diasCuota,
                                  onChanged: (value) {
                                    setState(() => bloc.changePayType(
                                        bloc.payType, value));
                                  },
                                ),
                              ),
                              ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      '30 días',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Radio(
                                  value: 3,
                                  groupValue: bloc.diasCuota,
                                  onChanged: (value) {
                                    setState(() => bloc.changePayType(
                                        bloc.payType, value));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
              ],
            );
          },
        ),
        actions: [
          FlatButton(
            child: Text("Aceptar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final productBloc = context.watch<ProductosBLoC>();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(11.5),
          child: Card(
            color: Colors.blue[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            margin: EdgeInsets.zero,
            elevation: 18,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
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
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
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
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                        splashColor: Colors.blue,
                        iconSize: 30.0,
                        onPressed: () async {
                          if (bloc.client.id != null) {
                            return buildEditDialog(context, bloc);
                          }
                        },
                      ),
                      Text(
                        bloc.payType == null
                            ? 'No Seleccionado'
                            : bloc.payType == 1
                                ? 'Efectivo'
                                : 'Crédito\n${bloc.diasCuota == null ? '' : bloc.numDias} días a pagar',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$${formatter.format(bloc.totalPrice)}',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey,
                    thickness: 1.5,
                    height: 0,
                  ),
                  itemCount: bloc.preSaleList.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 8.0,
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
                                  return buildResponseDialog(
                                      context, response, productBloc);
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
                        fontSize: MediaQuery.of(context).size.width * 0.06,
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
