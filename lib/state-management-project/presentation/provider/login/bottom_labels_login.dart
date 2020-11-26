import 'package:flutter/material.dart';

class BottomLabels extends StatelessWidget {
  const BottomLabels({
    Key key,
    @required this.size,
    this.endIndent,
    this.indent,
    this.sizeForgotPass,
    this.fontSizeNotAccount = 15,
    this.fontSizeContact = 17,
    this.fontSizeTerms = 17,
  }) : super(key: key);
  final Size size;
  final double indent;
  final double endIndent;
  final double sizeForgotPass;
  final double fontSizeNotAccount;
  final double fontSizeContact;
  final double fontSizeTerms;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // FlatButton(
          //   onPressed: () {},
          //   child: Text(
          //     'Olvidé la contraseña',
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontSize: sizeForgotPass,
          //         fontWeight: FontWeight.w500),
          //   ),
          // ),
          SizedBox(
            height: size.height * 0.025,
          ),
          Divider(
            thickness: 1.2,
            color: Colors.black54,
            indent: indent,
            endIndent: endIndent,
          ),
          Text(
            '¿No tienes cuenta?',
            style: TextStyle(
                color: Colors.black54,
                fontSize: fontSizeNotAccount,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
          Text(
            'Contáctate con el administrador al correo:\nadmin@example.com',
            style: TextStyle(fontSize: fontSizeContact),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: size.height * 0.09,
          ),
        ],
      ),
    );
  }
}
