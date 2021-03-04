import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:arturo_bruna_app/domain/model/product.dart';
import 'package:arturo_bruna_app/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/presentation/common/alert_dialog.dart';
import 'package:arturo_bruna_app/presentation/home/productos/item-product.dart';
import 'package:arturo_bruna_app/presentation/home/preventas/preventas_bloc.dart';
import 'package:arturo_bruna_app/presentation/home/productos/productos_bloc.dart';
import 'package:arturo_bruna_app/presentation/home/productos/product_search_delegate.dart';

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

  @override
  Widget build(BuildContext context) {
    final productsBloc = context.watch<ProductosBLoC>();
    final preSaleBLoC = context.watch<PreSaleBLoC>();
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: buildAppBarProducts(context, productsBloc, preSaleBLoC),
        body: productsBloc.productList.isNotEmpty
            ? RefreshIndicator(
                color: Colors.white,
                onRefresh: () async {
                  await productsBloc.loadProducts();
                },
                backgroundColor: Colors.blue[800],
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 4
                        : 2,
                    childAspectRatio: 0.5 / MediaQuery.textScaleFactorOf(context),
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemBuilder: (context, index) {
                    final product = productsBloc.productList[index];
                    return ItemProduct(
                      size: size,
                      product: product,
                      onTap: () async {
                        if (product.stockminimo != null) {
                          if (product.stock > 1) {
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
                                        _showNumberPicker(context, product,
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
                              _showNumberPicker(
                                  context, product, productsBloc, preSaleBLoC);
                          } else if (product.stock == 1) {
                            return showDialog(
                              context: context,
                              builder: (_) => AlertDialogPage(
                                oldContext: _,
                                content: Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    "Si confirma la pre-venta, este producto quedará sin stock.",
                                    style: TextStyle(fontSize: 18.5),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                actions: [
                                  FlatButton(
                                    child: Text(
                                      "Seguir...",
                                      style: TextStyle(fontSize: 17.0),
                                    ),
                                    shape: StadiumBorder(),
                                    onPressed: () {
                                      print(
                                          'Cantidad:  ${productsBloc.cantidadProducto}');
                                      preSaleBLoC.add(product, 1);
                                      productsBloc.cantidadProducto = 1;
                                      Navigator.of(context).pop();
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
                        } else {
                          if (product.stock != 0) {
                            _showNumberPicker(
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

  AppBar buildAppBarProducts(BuildContext context, ProductosBLoC productsBloc,
      PreSaleBLoC preSaleBLoC) {
    return AppBar(
      centerTitle: true,
      elevation: 6.0,
      backgroundColor: Colors.blue[900],
      toolbarHeight: 42.0,
      title: Text(
        'Productos',
        style: TextStyle(
          fontSize: 25.0,
        ),
      ),
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
    );
  }

  Future _showNumberPicker(BuildContext context, Producto product,
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
              print('Cantidad:  ${productsBLoC.cantidadProducto}');
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
}
