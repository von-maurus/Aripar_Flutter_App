import 'package:flutter/material.dart';

class BottomLabels extends StatelessWidget {
  const BottomLabels({Key key, @required this.size}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text(
              'Olvidé la contraseña',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Divider(
            thickness: 2.1,
            color: Colors.black54,
            indent: size.width * 0.06,
            endIndent: size.width * 0.06,
          ),
          Text(
            '¿No tienes cuenta?',
            style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
          Text(
            'Contáctate con el administrador al correo:\nadmin@example.com',
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.09),
            child: Container(
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
