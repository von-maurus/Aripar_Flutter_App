import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:arturo_bruna_app/constants.dart';
import 'package:arturo_bruna_app/size_config.dart';

class BottomMenuBar extends StatelessWidget {
  const BottomMenuBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.lightBlueAccent[700],
      child: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: "assets/icons/home.svg",
                title: "Inicio",
                press: () {
                  print("ir a inicio");
                },
                isActive: true,
              ),
              _NavItem(
                icon: "assets/icons/local_shipping.svg",
                title: "Delivery",
                press: () {
                  print("ir a despachos");
                },
              ),
              _NavItem(
                icon: "assets/icons/monetization.svg",
                title: "Ventas",
                press: () {
                  print("ir a pre ventas");
                },
              ),
              _NavItem(
                icon: "assets/icons/notification_important.svg",
                title: "Notificación",
                press: () {
                  print("ir a notificaciones");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.press,
    this.isActive = false,
  }) : super(key: key);
  final String icon, title;
  final GestureTapCallback press;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        padding: EdgeInsets.all(5),
        height: getProportionateScreenWidth(60),
        width: getProportionateScreenWidth(71),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent[700],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [if (isActive) kDefaultShadow],
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              color: kBottomBarColor,
              height: SizeConfig.screenHeight * 0.047,
            ),
            Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
