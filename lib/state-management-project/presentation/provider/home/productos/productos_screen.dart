import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/productos/product_search_delegate.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/theme.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/delivery_button.dart';
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

  @override
  Widget build(BuildContext context) {
    final productsBloc = context.watch<ProductosBLoC>();
    // final cartBloc = context.watch<CartBLoC>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            color: Colors.white,
            onPressed: () async {
              final producto = await showSearch(
                  context: context,
                  delegate: ProductSearchDelegate('Buscar producto',
                      productosBLoC: productsBloc));
              if (producto != null) {
                if (!productsBloc.historial
                    .any((element) => element.id == producto.id)) {
                  if (productsBloc.historial.length >= 10) {
                    productsBloc.historial.removeLast();
                    productsBloc.historial.insert(0, producto);
                  } else {
                    productsBloc.historial.insert(0, producto);
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
          style: TextStyle(letterSpacing: 1.0, fontSize: 25.0),
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
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 9,
                  mainAxisSpacing: 9,
                ),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final product = productsBloc.productList[index];
                  return _ItemProduct(
                      product: product,
                      onTap: () {
                        print(product.nombre);
                        // cartBloc.add(product);
                      });
                },
                itemCount: productsBloc.productList.length,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black45,
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
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final productsBloc = context.watch<ProductosBLoC>();

    Widget _buildAlertDialog(BuildContext context) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text('Cantidad'),
          content: NumberPicker.integer(
              initialValue: 0,
              minValue: 0,
              maxValue: product.stock,
              onChanged: (newValue) {
                productsBloc.cantidadProducto = newValue;
              }),
          actions: [
            FlatButton(
              child: Text('Continuar'),
              onPressed: () {
                print(productsBloc.cantidadProducto);
                // Navigator.of(context).pop();
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
          content: NumberPicker.integer(
              initialValue: 0,
              minValue: 0,
              maxValue: product.stock,
              onChanged: (newValue) {
                productsBloc.cantidadProducto = newValue;
              }),
          actions: [
            FlatButton(
              child: Text('Continuar'),
              onPressed: () {
                print(productsBloc.cantidadProducto);
                // Navigator.of(context).pop();
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

    Future _showMyDialog(BuildContext context) async {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _buildAlertDialog(_),
      );
    }

    return Card(
      margin: EdgeInsets.only(right: 12, left: 12, top: 10),
      elevation: 10,
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
                      radius: 10,
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
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.descripcion,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: DeliveryColors.dark, fontSize: 11.5),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${product.precioventa} CLP',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DeliveryButton(
                    onTap: () => _showMyDialog(context),
                    padding: const EdgeInsets.symmetric(vertical: 9.5),
                    text: "Añadir",
                  )
                ],
              ),
              Positioned(
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: product.stock < product.stockminimo
                        ? Colors.red
                        : Colors.green,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  child: Center(
                    child: Text(
                      product.stock.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                right: 0,
              )
            ],
          )),
    );
  }
}
