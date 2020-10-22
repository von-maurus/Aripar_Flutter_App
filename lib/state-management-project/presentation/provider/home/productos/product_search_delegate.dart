import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/productos/productos_bloc.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';

class ProductSearchDelegate extends SearchDelegate<Producto> {
  final ProductosBLoC productosBLoC;
  @override
  final String searchFieldLabel;
  ProductSearchDelegate(this.searchFieldLabel, {this.productosBLoC});

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
      return Center(child: Text("Ingrese un valor válido"));
    }
    return FutureBuilder(
        future: productosBLoC.getProductsByNameCode(query),
        builder: (_, AsyncSnapshot snapshot) {
          if (productosBLoC.productsByName.length != 0) {
            // Crear lista
            return _showProducts(productosBLoC.productsByName);
          } else if (snapshot.connectionState == ConnectionState.done &&
              productosBLoC.productsByName.length == 0) {
            return Center(child: Text("No se encontró el producto"));
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
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
      itemBuilder: (context, index) {
        final product = productos[index];
        return ListTile(
          onTap: () {
            _showMyDialog(context, product)
                .then((value) => this.close(context, product));
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
            style: TextStyle(fontSize: 15),
          ),
          subtitle: Text(
            'Código: ' + product.codigo,
            maxLines: 1,
            style: TextStyle(fontSize: 11.5),
          ),
          trailing: Text('\$' + product.precioventa.toString()),
        );
      },
      itemCount: productos.length,
    );
  }

  Widget _buildAlertDialog(BuildContext context, Producto producto) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text('Cantidad'),
        content: CustomNumberPicker(
            onValue: (value) {
              print(value);
            },
            initialValue: 1,
            maxValue: producto.stock,
            minValue: 1),
        actions: [
          FlatButton(
            child: Text('Agregar'),
            onPressed: () {
              // print(productsBloc.cantidadProducto);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text('Cantidad'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomNumberPicker(
                onValue: (value) {
                  print(value);
                },
                initialValue: 1,
                maxValue: producto.stock,
                minValue: 1)
          ],
        ),
        actions: [
          FlatButton(
            child: Text('Continuar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }

  Future _showMyDialog(BuildContext context, Producto producto) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _buildAlertDialog(_, producto),
    );
  }
}
