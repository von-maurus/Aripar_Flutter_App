import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:arturo_bruna_app/domain/model/product.dart';
import 'package:arturo_bruna_app/presentation/common/delivery_button.dart';
import 'package:arturo_bruna_app/presentation/common/theme.dart';

class ItemProduct extends StatelessWidget {
  ItemProduct({
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
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            buildProductInfo(context),
            buildStockViewer(context),
          ],
        ),
      ),
    );
  }

  Widget buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: product.imagen == null
              ? ClipOval(
                  child: SvgPicture.asset(
                    "assets/icons/product-cart.svg",
                    height: 85,
                    width: 85,
                    color: Colors.blue,
                  ),
                )
              : CircleAvatar(
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
                  fontSize:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 25
                          : 30,
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
                          ? 22
                          : 25,
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
                          fontSize: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 30.0
                              : 35.0),
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
          fontSize: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.04
              : MediaQuery.of(context).size.width * 0.025,
        )
      ],
    );
  }

  Widget buildStockViewer(BuildContext context) {
    return Positioned(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color:
              product.stockminimo != null && product.stock < product.stockminimo
                  ? Colors.red
                  : Colors.green,
          borderRadius: BorderRadius.circular(60),
        ),
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.088
              : MediaQuery.of(context).size.width * 0.045,
          minHeight: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.088
              : MediaQuery.of(context).size.width * 0.045,
        ),
        child: Center(
          child: Text(
            product.stock.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.width * 0.04
                      : MediaQuery.of(context).size.width * 0.024,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      right: 0,
    );
  }
}
