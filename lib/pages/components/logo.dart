import 'package:arturo_bruna_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

class Logo extends StatelessWidget {
  const Logo({Key key, @required this.size}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(top: getProportionateScreenHeight(60.0)),
      child: Column(
        children: <Widget>[
          Image.asset(
            "assets/images/aripar_white_logo.png",
            fit: BoxFit.cover, height: getProportionateScreenHeight(135.0),
            width: getProportionateScreenWidth(245.0),
            // height: getProportionateScreenHeight(2),
          ),
          // SvgPicture.asset(
          //   "assets/icons/aripar2.svg",
          //   height: size.height * 0.24,
          // ),
          SizedBox(
            height: size.height * 0.045,
          ),
          // Text(
          //   "AriApp",
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          // ),
        ],
      ),
    );
  }
}
