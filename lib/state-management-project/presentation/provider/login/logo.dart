import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/size_config.dart';

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
            fit: BoxFit.fitHeight, height: getProportionateScreenHeight(135.0),
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
