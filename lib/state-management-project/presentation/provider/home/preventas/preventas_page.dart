import 'package:flutter/material.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/constants.dart';

//TODO: Seleccionar el cliente o crearlo en caso de que no exista.
//TODO: Seleccionar los productos para una pre-venta.
//TODO: Opción de cambiar método de pago del cliente.
//TODO: Filtrar a los clientes que aun no pagan ventas previas (clientes bloqueados).
//TODO: Enviar una notificación al/los admin para "habilitar" una preventa cuando se crea.
//TODO: Recibir notificación por parte del/los admin cuando "habilíte" una preventa creada por el usuario. (vista notificaciones)
//TODO: Si es rol "Admin" mostrar dos secciones extras: "Preventas por Habilitar" y "Preventas habilitadas" (activate and deactivate preventa).

class PreVentasPage extends StatefulWidget {
  @override
  _PreVentasPageState createState() => _PreVentasPageState();
}

class _PreVentasPageState extends State<PreVentasPage> {
  int _timeHour = TimeOfDay.now().hour;

  Widget _greetingsWidget() {
    print(_timeHour);
    if (_timeHour >= 5 && _timeHour < 12) {
      return Text("Buenos Dias",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white));
    } else if (_timeHour >= 12 && _timeHour < 20) {
      return Text("Buenas Tardes",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white));
    } else {
      return Text("Buenas Noches",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
          height: MediaQuery.of(context).size.height * 0.42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
            color: kScaffoldBackgroundColor,
          ),
          width: double.infinity,
        ),
        Container(
          margin: EdgeInsets.only(
              left: 90,
              bottom: 20,
              top: MediaQuery.of(context).size.height * 0.04),
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.42,
          decoration: BoxDecoration(
              color: Colors.blueAccent[700],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(160),
                  bottomLeft: Radius.circular(290),
                  bottomRight: Radius.circular(160),
                  topRight: Radius.circular(10))),
        ),
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(26.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _greetingsWidget(),
                    Text("Mauricio",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    )));
  }
}
