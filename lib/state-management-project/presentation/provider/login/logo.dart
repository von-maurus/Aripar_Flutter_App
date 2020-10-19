import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key key, @required this.size}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Column(
        children: <Widget>[
          Image.asset(
            "assets/images/aripar_white_logo.png",
            fit: BoxFit.contain,
            height: size.height * 0.15,
            width: size.width * 0.58,
          ),
          SizedBox(
            height: size.height * 0.045,
          ),
        ],
      ),
    );
  }
}
