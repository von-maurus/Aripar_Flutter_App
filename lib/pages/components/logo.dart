import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  const Logo({Key key, @required this.size}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            "assets/icons/aripar2.svg",
            height: size.height * 0.28,
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
          Text(
            "Welcome to Aripar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
        ],
      ),
    );
  }
}
