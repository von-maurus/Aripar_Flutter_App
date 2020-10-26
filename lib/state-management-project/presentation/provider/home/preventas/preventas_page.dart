import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/state-management-project/domain/model/preventa_cart.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/preventas/preventas_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/delivery_button.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/theme.dart';

//TODO: Bug 1: Cuando el precioLinea aumenta a 100k ocurre overflow
//TODO: Bug 2: Arreglar vista horizontal del ListView
class PreSalePage extends StatelessWidget {
  final VoidCallback onShopping;
  PreSalePage({Key key, this.onShopping});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PreSaleBLoC>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        elevation: 6.0,
        title: Text(
          'Carrito de Ventas',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      body: bloc.totalItems == 0
          ? EmptyCart(
              onShopping: onShopping,
            )
          : _FullCart(),
    );
  }
}

class _FullCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PreSaleBLoC>();
    final total = bloc.totalPrice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: OrientationBuilder(
              builder: (_, orientation) {
                if (orientation == Orientation.landscape) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: bloc.preSaleList.length,
                    scrollDirection: Axis.vertical,
                    itemExtent: 250,
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
                  );
                }
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: bloc.preSaleList.length,
                  scrollDirection: Axis.vertical,
                  itemExtent: 250,
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
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(20),
              // ),
              // color: Theme.of(context).canvasColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cliente',
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
                                        color: Colors.blue,
                                        fontSize: 16.5,
                                      ),
                            ),
                            bloc.client.nombre == null
                                ? Text("No seleccionado",
                                    textAlign: TextAlign.right,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color: Colors.blue,
                                          fontSize: 16.5,
                                        ))
                                : Text(
                                    '${bloc.client.nombre} \n ${bloc.client.rut}',
                                    textAlign: TextAlign.right,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color: Colors.blue,
                                          fontSize: 16.5,
                                        ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Método de pago',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: Colors.blue, fontSize: 16.5),
                            ),
                            bloc.payType == null
                                ? Text(
                                    "No seleccionado",
                                    textAlign: TextAlign.right,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color: Colors.blue,
                                          fontSize: 16.5,
                                        ),
                                  )
                                : bloc.payType == 1
                                    ? Text(
                                        'Efectivo',
                                        textAlign: TextAlign.right,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                              color: Colors.blue,
                                              fontSize: 16.5,
                                            ),
                                      )
                                    : Text(
                                        'Crédito',
                                        textAlign: TextAlign.right,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                              color: Colors.blue,
                                              fontSize: 16.5,
                                            ),
                                      ),
                          ],
                        ),
                        const SizedBox(height: 45.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            Text(
                              '\$$total CLP',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DeliveryButton(
                    text: 'Realizar preventa',
                    onTap: () {
                      // TODO: Llamar al servicio de createPreventa
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
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
    final product = preSaleCart.product;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Card(
            elevation: 12.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
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
                  const SizedBox(height: 5),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          product.nombre,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.descripcion,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: DeliveryColors.dark,
                                fontSize: 12,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: onDecrement,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: DeliveryColors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    Icons.remove,
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
                                ),
                              ),
                              InkWell(
                                onTap: onIncrement,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: DeliveryColors.purple,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: DeliveryColors.white,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text(
                                '\$${preSaleCart.precioLinea} ',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
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
                  color: Colors.black,
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
      body: Column(
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
                  style: TextStyle(color: DeliveryColors.white, fontSize: 16.5),
                ),
              ),
              onPressed: onShopping,
            ),
          ),
        ],
      ),
    );
  }
}
