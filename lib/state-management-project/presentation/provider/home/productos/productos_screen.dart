import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/alert_dialog.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/theme.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/delivery_button.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/preventas/preventas_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/productos/product_search_delegate.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/productos/productos_bloc.dart';

class ProductosScreen extends StatelessWidget {
  ProductosScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductosBLoC(
          apiRepositoryInterface: context.read<ApiRepositoryInterface>())
        ..loadProducts(),
      builder: (_, __) => ProductosScreen._(),
    );
  }

  Future _showMyDialog(BuildContext context, Producto product,
      ProductosBLoC productsBLoC, PreSaleBLoC preSaleBLoC) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        title: Center(
          child: Text("Seleccione la cantidad"),
        ),
        content: NumberPicker.integer(
          initialValue: 1,
          minValue: 1,
          highlightSelectedValue: true,
          haptics: true,
          maxValue: product.stock,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
          ),
          onChanged: (newValue) {
            productsBLoC.cantidadProducto = newValue;
          },
        ),
        actions: [
          FlatButton(
            child: Text(
              "Agregar",
              style: TextStyle(fontSize: 17.0),
            ),
            shape: StadiumBorder(),
            onPressed: () async {
              print('Cantidad que le paso  ${productsBLoC.cantidadProducto}');
              preSaleBLoC.add(product, productsBLoC.cantidadProducto);
              productsBLoC.cantidadProducto = 1;
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

  @override
  Widget build(BuildContext context) {
    final productsBloc = context.watch<ProductosBLoC>();
    final preSaleBLoC = context.watch<PreSaleBLoC>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              color: Colors.white,
              onPressed: () async {
                final product = await showSearch(
                    context: context,
                    delegate: ProductSearchDelegate('Buscar producto',
                        productosBLoC: productsBloc, preSaleBLoC: preSaleBLoC));
                if (product != null) {
                  //TODO: Guardar historial de busqueda en SharedPreferences localmente
                  if (!productsBloc.historial
                      .any((element) => element.id == product.id)) {
                    if (productsBloc.historial.length >= 10) {
                      productsBloc.historial.removeLast();
                      productsBloc.historial.insert(0, product);
                    } else {
                      productsBloc.historial.insert(0, product);
                    }
                  }
                }
              },
              splashColor: Colors.transparent,
            )
          ],
          centerTitle: true,
          elevation: 6.0,
          title: Text(
            'Productos',
            style: TextStyle(fontSize: 25.0),
          ),
          backgroundColor: Colors.blue[900],
        ),
        body: productsBloc.productList.isNotEmpty
            ? RefreshIndicator(
                color: Colors.white,
                onRefresh: () async {
                  productsBloc.loadProducts();
                },
                backgroundColor: Colors.blue[800],
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 4
                        : 2,
                    childAspectRatio: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 2 / 3.4
                        : 2 / 3,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 9,
                  ),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final product = productsBloc.productList[index];
                    return _ItemProduct(
                      product: product,
                      onTap: () async {
                        if (product.stock != 0) {
                          if (product.stock <= product.stockminimo) {
                            return showDialog(
                              context: context,
                              builder: (_) => AlertDialogPage(
                                oldContext: _,
                                title: Center(
                                  child: Text(
                                    "Advertencia",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0),
                                  ),
                                ),
                                content: Text(
                                  "El producto se encuentra con Stock Mínimo. Por favor, notifique a su administrador",
                                  style: TextStyle(fontSize: 18.5),
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  FlatButton(
                                    child: Text(
                                      "Seguir...",
                                      style: TextStyle(fontSize: 17.0),
                                    ),
                                    shape: StadiumBorder(),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _showMyDialog(context, product,
                                          productsBloc, preSaleBLoC);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      "Volver",
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
                          } else
                            _showMyDialog(
                                context, product, productsBloc, preSaleBLoC);
                        } else {
                          return showDialog(
                            context: context,
                            builder: (_) => AlertDialogPage(
                              oldContext: _,
                              title: Center(
                                child: Text(
                                  "Alerta",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                              ),
                              content: Text(
                                "El producto se encuentra SIN STOCK. Por favor, notifique a su administrador.",
                                style: TextStyle(fontSize: 18.5),
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    "Aceptar",
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
                      },
                    );
                  },
                  itemCount: productsBloc.productList.length,
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black45,
                ),
              ),
      ),
    );
  }
}

class _ItemProduct extends StatelessWidget {
  _ItemProduct({
    Key key,
    this.product,
    this.onTap,
  }) : super(key: key);
  final Producto product;
  final Function onTap;
  final formatter = new NumberFormat.currency(
    locale: 'es',
    decimalDigits: 0,
    symbol: '',
  );
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
          right: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.01
              : MediaQuery.of(context).size.width * 0.0001,
          left: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.01
              : MediaQuery.of(context).size.width * 0.0001,
          top: 25),
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.network(
                        product.imagen,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        product.nombre,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? MediaQuery.of(context).size.width * 0.045
                              : MediaQuery.of(context).size.width * 0.023,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                      Text(
                        product.descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: DeliveryColors.darkGrey,
                              fontSize: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? MediaQuery.of(context).size.width * 0.04
                                  : MediaQuery.of(context).size.width * 0.02,
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              '\$${formatter.format(product.precioVentaFinal)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: MediaQuery.of(context)
                                              .orientation ==
                                          Orientation.portrait
                                      ? MediaQuery.of(context).size.width * 0.05
                                      : MediaQuery.of(context).size.width *
                                          0.035),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                DeliveryButton(
                  onTap: onTap,
                  padding: const EdgeInsets.symmetric(vertical: 9.5),
                  text: "Añadir",
                  fontSize:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.width * 0.04
                          : MediaQuery.of(context).size.width * 0.025,
                )
              ],
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: product.stock < product.stockminimo
                      ? Colors.red
                      : Colors.green,
                  borderRadius: BorderRadius.circular(60),
                ),
                constraints: BoxConstraints(
                  minWidth:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.width * 0.088
                          : MediaQuery.of(context).size.width * 0.045,
                  minHeight:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.width * 0.088
                          : MediaQuery.of(context).size.width * 0.045,
                ),
                child: Center(
                  child: Text(
                    product.stock.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.width * 0.04
                          : MediaQuery.of(context).size.width * 0.024,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              right: 0,
            )
          ],
        ),
      ),
    );
  }
}
