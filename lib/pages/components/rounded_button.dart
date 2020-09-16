import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/constants.dart';

class RoundedButton extends StatelessWidget {
  final Size size;
  final Color borderColor;
  final Color buttonColor;
  final String buttonText;
  final Function onPressed;
  final Color buttonTextColor;

  const RoundedButton(
      {Key key,
      @required this.size,
      @required this.onPressed,
      this.borderColor = kBorderButton,
      this.buttonColor = kButtonPrimary,
      this.buttonText = 'TextButton',
      this.buttonTextColor = kTextRoundedButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 3.5,
      highlightElevation: 8,
      color: buttonColor,
      shape: StadiumBorder(side: BorderSide(color: borderColor)),
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: size.height * 0.069,
        child: Center(
            child: Text(
          buttonText,
          style: TextStyle(color: buttonTextColor, fontSize: 18.5),
        )),
      ),
    );
  }
}
