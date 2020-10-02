import 'package:flutter/material.dart';

//TODO: Seleccionar el cliente o crearlo en caso de que no exista.
//TODO: Seleccionar los productos para una pre-venta.
//TODO: Opción de cambiar método de pago del cliente.
//TODO: Filtrar a los clientes que aun no pagan ventas previas (clientes bloqueados).
//TODO: Enviar una notificación al/los admin para "habilitar" una preventa cuando se crea.
//TODO: Recibir notificación por parte del/los admin cuando "habilíte" una preventa creada por el usuario.
//TODO: Si es rol "Admin" mostrar dos secciones extras: "Preventas por Habilitar" y "Preventas habilitadas" (activate and deactivate preventa).

class PreVentasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: Text("Pre Ventas Page"),
      )),
    );
  }
}
