import 'package:flutter/material.dart';

class CustomFormInput extends StatelessWidget {
  final Size size;
  final Icon prefixIcon;
  final String hintText;
  final String errorText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isObscure;
  final FocusNode focusNode;
  final FormFieldValidator<String> validator;
  final TextInputAction textInputAction;
  final Function function;
  final AutovalidateMode autoValidateMode;
  final Widget suffixWidget;
  const CustomFormInput(
      {Key key,
      @required this.size,
      @required this.controller,
      @required this.hintText,
      @required this.prefixIcon,
      this.focusNode,
      this.textInputType = TextInputType.text,
      this.errorText,
      this.isObscure = false,
      this.validator,
      this.textInputAction,
      this.function,
      this.autoValidateMode,
      this.suffixWidget})
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
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.099),
            offset: Offset(0, 5),
            blurRadius: 6.5)
      ], color: Colors.white, borderRadius: BorderRadius.circular(30.0)),
      child: TextFormField(
        autovalidateMode: autoValidateMode,
        textInputAction: textInputAction,
        onFieldSubmitted: function,
        validator: validator,
        focusNode: focusNode,
        obscureText: isObscure,
        controller: controller,
        onEditingComplete: () {
          return print(controller.value.text);
        },
        autocorrect: false,
        keyboardType: textInputType,
        decoration: InputDecoration(
          suffixIcon: suffixWidget,
          disabledBorder: InputBorder.none,
          errorText: errorText,
          hintText: hintText,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: prefixIcon,
          errorStyle: TextStyle(fontSize: 16.0),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 18),
        ),
      ),
    );
  }
}
