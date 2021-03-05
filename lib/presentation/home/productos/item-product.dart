import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:arturo_bruna_app/domain/model/product.dart';
import 'package:arturo_bruna_app/presentation/common/delivery_button.dart';
import 'package:arturo_bruna_app/presentation/common/theme.dart';

class ItemProduct extends StatelessWidget {
  ItemProduct({Key key, this.product, this.onTap, this.size}) : super(key: key);
  final Producto product;
  final Function onTap;
  final formatter = new NumberFormat.currency(
    locale: 'es',
    decimalDigits: 0,
    symbol: '',
  );
  final Size size;

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
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            buildProductInfo(context, size),
            buildStockViewer(context),
          ],
        ),
      ),
    );
  }

  Widget buildProductInfo(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: product.imagen == null
              ? Container(
                  padding: EdgeInsets.all(size.width >= 750.0 ? 10.0 : 50.0),
                  child: SvgPicture.asset(
                    "assets/icons/product-cart.svg",
                    color: Colors.blue,
                  ),
                )
              : Container(
                  child: Image.network(
                    product.imagen,
                    fit: BoxFit.fitHeight,
                  ),
                ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                product.nombre,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  fontSize:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? size.width >= 600
                              ? 19.5
                              : 15.5
                          : size.width >= 750
                              ? 19.5
                              : 15.5,
                  fontWeight: FontWeight.bold,
                ),
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
                          ? size.width >= 600
                              ? 18.5
                              : 13.5
                          : size.width >= 750
                              ? 19.0
                              : 14.0,
                    ),
              ),
              Text(
                '\$${formatter.format(product.precioVentaFinal)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontSize:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? size.width >= 600
                              ? 28.0
                              : 18.0
                          : size.width >= 750
                              ? 26.0
                              : 19.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          child: DeliveryButton(
            onTap: onTap,
            padding: const EdgeInsets.symmetric(vertical: 9.5),
            text: "Añadir",
            fontSize: MediaQuery.of(context).orientation == Orientation.portrait
                ? 30.0
                : 22.5,
          ),
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
