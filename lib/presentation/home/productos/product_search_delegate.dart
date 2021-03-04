import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:arturo_bruna_app/domain/model/product.dart';
import 'package:arturo_bruna_app/presentation/common/alert_dialog.dart';
import 'package:arturo_bruna_app/presentation/home/preventas/preventas_bloc.dart';
import 'package:arturo_bruna_app/presentation/home/productos/productos_bloc.dart';

class ProductSearchDelegate extends SearchDelegate<Producto> {
  final ProductosBLoC productosBLoC;
  final PreSaleBLoC preSaleBLoC;

  @override
  final String searchFieldLabel;

  ProductSearchDelegate(this.searchFieldLabel,
      {this.productosBLoC, this.preSaleBLoC});

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
        "Ingrese un producto",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
      ));
    }
    return FutureBuilder(
        future: productosBLoC.getProductsByNameCode(query),
        builder: (_, AsyncSnapshot snapshot) {
          if (productosBLoC.productsByName.length != 0) {
            // Crear lista
            return _showProducts(productosBLoC.productsByName);
          } else if (snapshot.connectionState == ConnectionState.done &&
              productosBLoC.productsByName.length == 0) {
            return Center(
              child: Text(
                "No se encontró el producto",
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
    return _showProducts(productosBLoC.historial);
  }

  Widget _showProducts(List<Producto> productos) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final product = productos[index];
        return ListTile(
          leading: product.imagen != null
              ? Image(
                  width: 45,
                  image: NetworkImage(product.imagen),
                )
              : ClipOval(
                  child: SvgPicture.asset(
                    "assets/icons/product-cart.svg",
                    height: 45,
                    width: 45,
                    color: Colors.blue,
                  ),
                ),
          title: Text(
            product.nombre,
            maxLines: 1,
            style: TextStyle(fontSize: 16.5),
          ),
          subtitle: Text(
            'Código: ' + product.codigo,
            maxLines: 1,
            style: TextStyle(fontSize: 13.5),
          ),
          trailing: Text(
            '\$' + product.precioventa.toString(),
            style: TextStyle(fontSize: 18.5),
          ),
          onTap: () async {
            if (product.stock != 0) {
              if (product.stock <= product.stockminimo) {
                return showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialogPage(
                    oldContext: _,
                    title: Center(
                        child: Text(
                      'Advertencia',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    )),
                    content: Text(
                      "El producto se encuentra con Stock Mínimo. Por favor, notifique a su administrador",
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      FlatButton(
                        child: Text(
                          "Seguir...",
                          style: TextStyle(fontSize: 17.0),
                        ),
                        shape: StadiumBorder(),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          showSearchDialog(context, product);
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
                          this.close(context, product);
                        },
                      ),
                    ],
                  ),
                );
              } else {
                showSearchDialog(context, product);
              }
            } else {
              return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialogPage(
                  oldContext: _,
                  title: Center(
                      child: Text(
                    'Alerta',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  )),
                  content: Text(
                    "El producto se encuentra SIN STOCK. Por favor, notifique a su administrador",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    FlatButton(
                      child: Text(
                        "Volver",
                        style: TextStyle(fontSize: 17.0),
                      ),
                      shape: StadiumBorder(),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        this.close(context, product);
                      },
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  Future showSearchDialog(BuildContext context, Producto product) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        title: Text('Cantidad'),
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
            this.productosBLoC.cantidadProducto = newValue;
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
              preSaleBLoC.add(product, productosBLoC.cantidadProducto);
              productosBLoC.cantidadProducto = 1;
              Navigator.of(context).pop();
              this.close(context, product);
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
              this.close(context, product);
            },
          ),
        ],
      ),
    );
  }
}
