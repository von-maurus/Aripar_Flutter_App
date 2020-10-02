import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/pages/components/background.dart';
import 'package:arturo_bruna_app/pages/components/bottom_labels_login.dart';
import 'package:arturo_bruna_app/pages/components/custom_input.dart';
import 'package:arturo_bruna_app/pages/components/logo.dart';
import 'package:arturo_bruna_app/pages/components/rounded_button.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //provee height y width total de la pantalla
    Size size = MediaQuery.of(context).size;
    return Background(
      size: size,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Logo(
                size: size,
              ),
              _Form(
                size: size,
              ),
              BottomLabels(
                size: size,
              )
              // SvgPicture.asset("assets/icons/chat.svg", height: size.height * 0.45)
            ],
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  final Size size;

  const _Form({Key key, @required this.size}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.size.height * 0.02),
      padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.051),
      child: Column(
        children: <Widget>[
          CustomInput(
            size: widget.size,
            prefixIcon: Icon(Icons.email),
            hintText: 'Email',
            controller: _emailController,
            textInputType: TextInputType.emailAddress,
          ),
          CustomInput(
              isObscure: true,
              size: widget.size,
              prefixIcon: Icon(Icons.vpn_key),
              hintText: 'Contraseña',
              controller: _passController),
          RoundedButton(
            size: widget.size,
            buttonText: "Iniciar sesión",
            onPressed: () {},
            buttonColor: Colors.orange[500],
            buttonTextColor: Colors.black,
          )
        ],
      ),
    );
  }
}
