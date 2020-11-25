import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/state-management-project/domain/model/preventa_cart.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/alert_dialog.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/theme.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/home_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/preventas/preventas_bloc.dart';

class PreSalePage extends StatelessWidget {
  final VoidCallback onShopping;

  PreSalePage({Key key, this.onShopping});
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PreSaleBLoC>();
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[900],
            toolbarHeight:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 80.0
                    : 53,
            elevation: 6.0,
            bottom: TabBar(
              indicatorWeight: 6.5,
              indicatorColor: Colors.blue[200],
              tabs: [
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? Tab(
                        text: "Productos",
                      )
                    : Tab(
                        text: "Productos",
                        icon: Icon(
                          Icons.shopping_cart,
                          size: 25.0,
                        ),
                        iconMargin: EdgeInsets.all(2.0),
                      ),
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? Tab(
                        text: "Finalizar Venta",
                      )
                    : Tab(
                        text: "Finalizar Venta",
                        icon: Icon(
                          Icons.payments,
                          size: 25.0,
                        ),
                        iconMargin: EdgeInsets.all(2.0),
                      )
              ],
            ),
          ),
          body: bloc.totalItems == 0
              ? EmptyCart(
                  onShopping: onShopping,
                )
              : TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _ProductCartScreen(),
                    _CheckoutScreen(),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ProductCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PreSaleBLoC>();
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: RaisedButton(
                  onPressed: () {
                    if (bloc.preSaleList.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialogPage(
                          oldContext: _,
                          content: Text(
                            "Se limpiará el carrito de ventas. ¿Desea continuar?",
                            style: TextStyle(fontSize: 22.0),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                bloc.cleanSalesCart();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Continuar",
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                "Cancelar",
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        "Vaciar carro",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? MediaQuery.of(context).size.width * 0.02
                                : MediaQuery.of(context).size.width * 0.04),
                      ),
                      Icon(
                        Icons.clear,
                        size: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? MediaQuery.of(context).size.width * 0.03
                            : MediaQuery.of(context).size.width * 0.055,
                      )
                    ],
                  ),
                  shape: StadiumBorder(),
                ),
              )
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 2
                        : 2,
                childAspectRatio:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 2
                        : 2 / 3.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final preSaleCart = bloc.preSaleList[index];
                return _ShoppingCartProduct(
                  preSaleCart: preSaleCart,
                  onDelete: () {
                    bloc.deleteProduct(preSaleCart);
                  },
                  onIncrement: () {
                    bloc.increment(preSaleCart);
                  },
                  onDecrement: () {
                    bloc.decrement(preSaleCart);
                  },
                );
              },
              itemCount: bloc.preSaleList.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutScreen extends StatelessWidget {
  final formatter = new NumberFormat.currency(
    locale: 'es',
    decimalDigits: 0,
    symbol: '',
  );
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PreSaleBLoC>();
    final homeBloc = context.watch<HomeBLoC>();
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
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
                                      : bloc.client.nombre +
                                          '\n' +
                                          bloc.client.rut,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
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
                                      "Se creará la Pre-Venta.\n¿Desea continuar?...",
                                      style: TextStyle(fontSize: 18.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          //Esperar respuesta
                                          final response =
                                              await bloc.checkOut();
                                          //Mostrar AlertDialog con respuesta
                                          return buildResponseDialog(
                                              context, response);
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
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.025,
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
                                    "Se creará la Pre-Venta.\n¿Desea continuar?...",
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
                                            context, response);
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
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
        },
      ),
    );
  }

  Future<void> buildResponseDialog(BuildContext context, response) {
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
  // Widget _emptyCart(){
  //   return InkWell(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         MediaQuery.of(context).orientation == Orientation.landscape
  //             ? Container()
  //             : Padding(
  //           padding: const EdgeInsets.all(5.0),
  //           child: Text(
  //             "Limpiar",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.w500, fontSize: 18),
  //           ),
  //         ),
  //         Icon(
  //           Icons.restore_from_trash,
  //           size: MediaQuery.of(context).orientation==Orientation.landscape?,
  //           color: Colors.white,
  //           semanticLabel: "Limpiar",
  //         ),
  //       ],
  //     ),
  //     onTap: () async {
  //       if (bloc.preSaleList.isNotEmpty || bloc.client.id != null) {
  //         showDialog(
  //           context: context,
  //           builder: (_) => AlertDialogPage(
  //             oldContext: _,
  //             content: Text(
  //               "Se limpiara el carrito de compras. ¿Desea continuar?",
  //               style: TextStyle(fontSize: 22.0),
  //               textAlign: TextAlign.center,
  //             ),
  //             actions: [
  //               FlatButton(
  //                 onPressed: () {
  //                   bloc.cleanSalesCart();
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text(
  //                   "Continuar",
  //                   style: TextStyle(fontSize: 18.0),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ),
  //               FlatButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: Text(
  //                   "Cancelar",
  //                   style: TextStyle(fontSize: 18.0),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }
}

class _ShoppingCartProduct extends StatelessWidget {
  const _ShoppingCartProduct({
    Key key,
    this.preSaleCart,
    this.onDelete,
    this.onDecrement,
    this.onIncrement,
  }) : super(key: key);
  final PreSaleCart preSaleCart;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat.currency(
      locale: 'es',
      decimalDigits: 0,
      symbol: 'CLP',
    );
    final product = preSaleCart.product;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Card(
              elevation: 15.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.network(
                              product.imagen,
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.nombre,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            '\$${formatter.format(preSaleCart.precioLinea)} ',
                            maxLines: 1,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25.0,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: onDecrement,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    size: 36.0,
                                    color: DeliveryColors.purple,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  preSaleCart.quantity.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              InkWell(
                                onTap: onIncrement,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: DeliveryColors.purple,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: DeliveryColors.white,
                                    size: 35.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: onDelete,
                child: CircleAvatar(
                  backgroundColor: DeliveryColors.pink,
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white70,
                    size: 25.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Card(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.network(
                            product.imagen,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          product.nombre,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '\$${formatter.format(preSaleCart.precioLinea)} ',
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 25.0,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: onDecrement,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: 36.0,
                                  color: DeliveryColors.purple,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                preSaleCart.quantity.toString(),
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: onIncrement,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: DeliveryColors.purple,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: DeliveryColors.white,
                                  size: 35.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: InkWell(
              onTap: onDelete,
              child: CircleAvatar(
                backgroundColor: DeliveryColors.pink,
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.white70,
                  size: 25.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  final VoidCallback onShopping;

  const EmptyCart({Key key, this.onShopping}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/sad.png',
                height: 100,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              Text(
                'No hay productos',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              const SizedBox(height: 20),
              Center(
                child: RaisedButton(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: DeliveryColors.purple,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Ver Productos',
                      style: TextStyle(
                          color: DeliveryColors.white, fontSize: 16.5),
                    ),
                  ),
                  onPressed: onShopping,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
