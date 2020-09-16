import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final Size size;
  final Icon prefixIcon;
  final String hintText;
  final String errorText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isObscure;

  const CustomInput(
      {Key key,
      @required this.size,
      @required this.controller,
      @required this.hintText,
      @required this.prefixIcon,
      this.textInputType = TextInputType.text,
      this.errorText,
      this.isObscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.022),
      padding: EdgeInsets.only(
          top: size.height * 0.007,
          left: size.width * 0.007,
          bottom: size.height * 0.007,
          right: size.width * 0.05),
      child: TextField(
        obscureText: isObscure,
        controller: controller,
        autocorrect: false,
        keyboardType: textInputType,
        decoration: InputDecoration(
            disabledBorder: InputBorder.none,
            errorText: errorText,
            hintText: hintText,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIcon: prefixIcon),
      ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.099),
            offset: Offset(0, 5),
            blurRadius: 6.5)
      ], color: Colors.white, borderRadius: BorderRadius.circular(30.0)),
    );
  }
}
