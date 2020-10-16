import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/delivery_button.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
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
        centerTitle: true,
        elevation: 6.0,
        title: Text(
          'Productos',
          style: TextStyle(letterSpacing: 1.0, fontSize: 25.0),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: productsBloc.productList.isNotEmpty
          ? GridView.builder(
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
                      print(product.imagen);
                      // cartBloc.add(product);
                    });
              },
              itemCount: productsBloc.productList.length,
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
    return Card(
      margin: EdgeInsets.only(right: 12, left: 12, top: 10),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.0)),
      color: Theme.of(context).canvasColor,
      child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
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
                child: Column(
                  children: [
                    Text(
                      product.nombre,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.descripcion,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: DeliveryColors.dark, fontSize: 11.5),
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
                onTap: () {},
                padding: const EdgeInsets.symmetric(vertical: 9.5),
                text: "Añadir",
              )
            ],
          )),
    );
  }
}
