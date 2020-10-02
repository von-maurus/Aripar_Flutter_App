import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:arturo_bruna_app/size_config.dart';
import 'package:arturo_bruna_app/constants.dart';

class AnimatedBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChange;

  const AnimatedBottomBar({Key key, this.currentIndex, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(color: kBottomBarColor),
      child: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            children: [
              // Expanded(
              //   child: InkWell(
              //     onTap: () => onChange(0),
              //     child: _BottomNavItem(
              //       isActive: currentIndex == 0,
              //       iconSvg: "assets/icons/home.svg",
              //       title: "Inicio",
              //       activeColor: Colors.black,
              //     ),
              //   ),
              // ),
              // Expanded(
              //   child: InkWell(
              //     onTap: () => onChange(0),
              //     child: _BottomNavItem(
              //       isActive: currentIndex == 0,
              //       iconSvg: "assets/icons/local_shipping.svg",
              //       title: "",
              //       activeColor: kPrimaryColor2,
              //     ),
              //   ),
              // ),
              Expanded(
                child: InkWell(
                  onTap: () => onChange(0),
                  child: _BottomNavItem(
                    isActive: currentIndex == 0,
                    iconSvg: "assets/icons/monetization.svg",
                    title: "Pre-Ventas",
                    activeColor: kPrimaryColor2,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => onChange(1),
                  child: _BottomNavItem(
                    isActive: currentIndex == 1,
                    iconSvg: "assets/icons/notification_important.svg",
                    title: "Notificaciones",
                    activeColor: kPrimaryColor2,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color activeColor;
  final Color inactiveColor;
  final String title;
  final String iconSvg;

  const _BottomNavItem(
      {Key key,
      this.isActive = false,
      this.icon,
      this.activeColor,
      this.inactiveColor,
      this.title,
      this.iconSvg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
                  .animate(animation),
          child: child,
        );
      },
      duration: Duration(milliseconds: 250),
      reverseDuration: Duration(milliseconds: 100),
      child: isActive
          ? Container(
              color: kBottomBarColor,
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: activeColor ?? kScaffoldBackgroundColor,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeColor ?? kScaffoldBackgroundColor,
                    ),
                  ),
                ],
              ),
            )
          : icon != null
              ? Icon(
                  icon,
                  color: inactiveColor ?? Colors.grey,
                )
              : SvgPicture.asset(
                  iconSvg,
                  color: kScaffoldBackgroundColor,
                ),
    );
  }
}
