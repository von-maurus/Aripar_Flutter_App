import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/constants.dart';

class RoundedButton extends StatelessWidget {
  final Size size;
  final Color borderColor;
  final Color buttonColor;
  final String buttonText;
  final Function onPressed;
  final Color buttonTextColor;
  final double height;
  final double textFontSize;

  const RoundedButton(
      {Key key,
      @required this.size,
      @required this.onPressed,
      this.borderColor = kBorderButton,
      this.buttonColor = kButtonPrimary,
      this.buttonText = 'TextButton',
      this.buttonTextColor = kTextRoundedButton,
      this.height = 55.0,
      this.textFontSize = 18.5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 3.5,
      highlightElevation: 9,
      color: buttonColor,
      shape: StadiumBorder(side: BorderSide(color: borderColor)),
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: height,
        child: Center(
            child: Text(
          buttonText,
          style: TextStyle(color: buttonTextColor, fontSize: textFontSize),
        )),
      ),
    );
  }
}
