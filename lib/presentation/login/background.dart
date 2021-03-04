import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({Key key, @required this.size, @required this.child})
      : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                fit: BoxFit.fill,
              ),
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? size.width * 0.15
                  : size.width * 0.28,
            ),
            child,
          ],
        ));
  }
}
