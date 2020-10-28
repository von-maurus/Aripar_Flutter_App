import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/preventas/preventas_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/productos/productos_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/alert_dialog.dart';

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
        onPressed: () => this.close(context, null));
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
          onTap: () {
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
          },
          leading: product.imagen != null
              ? Image(
                  width: 45,
                  image: NetworkImage(product.imagen),
                )
              : '',
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
        );
      },
    );
  }
}
