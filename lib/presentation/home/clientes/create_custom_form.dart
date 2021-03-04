import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/presentation/common/rounded_button.dart';
import 'package:arturo_bruna_app/presentation/home/clientes/clientes_bloc.dart';

class CustomForm extends StatelessWidget {
  final ClientesBLoC clientsBLoC;
  final Size size;
  final maskFormatter;
  final scaffoldKey;

  const CustomForm(
      {Key key,
      this.clientsBLoC,
      this.size,
      this.maskFormatter,
      this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: buildFields(context),
          ),
        ),
        if (clientsBLoC.clientsState == ClientsState.loading)
          Container(
            color: Colors.black45,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }

  void onSubmit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final result = await clientsBLoC.submitData();
    if (result) {
      clientsBLoC.clearFields();
      Navigator.of(context).pop();
    } else {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          elevation: 5.0,
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 6400),
          content: buildResponseContent(),
        ),
      );
    }
  }

  Widget buildResponseContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Ocurrieron los siguientes errores:',
          style: TextStyle(fontSize: 18.0),
        ),
        clientsBLoC.simpleErrorMsg != null
            ? Text(
                clientsBLoC.simpleErrorMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              )
            : SizedBox.shrink(),
        clientsBLoC.complexErrorMsg != null
            ? clientsBLoC.complexErrorMsg['errors']['rut'] != null
                ? Text(
                    '- ${clientsBLoC.complexErrorMsg['errors']['rut'][0]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  )
                : SizedBox.shrink()
            : SizedBox.shrink(),
        clientsBLoC.complexErrorMsg != null
            ? clientsBLoC.complexErrorMsg['errors']['correo'] != null
                ? Text(
                    '- ${clientsBLoC.complexErrorMsg['errors']['correo'][0]}',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18.0,
                    ))
                : SizedBox.shrink()
            : SizedBox.shrink(),
      ],
    );
  }

  Widget buildCreditOptions() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.only(left: 25.0, right: 15.0),
      height: 57.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[600],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 2.5,
          ),
          DropdownButton(
            icon: Icon(Icons.timelapse),
            value: clientsBLoC.numDiasCuota,
            elevation: 10,
            isExpanded: true,
            dropdownColor: Colors.blue[100],
            items: [
              DropdownMenuItem<int>(
                value: 4,
                child: Row(
                  children: [
                    Text(
                      "Seleccione días a pagar",
                      style: TextStyle(
                        fontSize: 16.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem<int>(
                value: 1,
                child: Text(
                  "7 Días",
                  style: TextStyle(
                    fontSize: 16.5,
                    color: Colors.black,
                  ),
                ),
              ),
              DropdownMenuItem<int>(
                value: 2,
                child: Text(
                  "15 Días",
                  style: TextStyle(
                    fontSize: 16.5,
                    color: Colors.black,
                  ),
                ),
              ),
              DropdownMenuItem<int>(
                value: 3,
                child: Text(
                  "30 Días",
                  style: TextStyle(
                    fontSize: 16.5,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              print(value);
              clientsBLoC.changeNumCuotas(value.toString());
            },
          ),
        ],
      ),
    );
  }

  Widget buildClientTypeOptions() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.only(left: 25.0, right: 15.0),
      height: 57.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[600],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 2.5,
          ),
          DropdownButton(
            value: clientsBLoC.clientType,
            elevation: 10,
            isExpanded: true,
            dropdownColor: Colors.blue[100],
            items: [
              DropdownMenuItem<int>(
                value: 3,
                child: Row(
                  children: [
                    Text(
                      "Seleccione el tipo de cliente",
                      style: TextStyle(
                        fontSize: 16.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Text(
                      "Minorista",
                      style: TextStyle(
                        fontSize: 16.5,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Text(
                      "Mayorista",
                      style: TextStyle(
                        fontSize: 16.5,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              print(value);
              clientsBLoC.changeType(value.toString());
            },
          ),
        ],
      ),
    );
  }

  Widget buildFields(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          onChanged: (String value) {
            clientsBLoC.changeName(value);
          },
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: "Nombre",
            errorText: clientsBLoC.nombre.error,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          inputFormatters: [maskFormatter],
          onChanged: (String value) {
            if (clientsBLoC.maskFormatter.getUnmaskedText().length < 8) {
              clientsBLoC.maskFormatter.updateMask(mask: '#.###.###-#');
            } else {
              clientsBLoC.maskFormatter.updateMask(mask: '##.###.###-#');
            }
            clientsBLoC.changeRUN(value);
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_search_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: "RUT",
            hintText: "90.000.000-0",
            errorText: clientsBLoC.rut.error,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.alternate_email),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: "Correo",
            hintText: "example@mail.com",
            errorText: clientsBLoC.correo.error,
          ),
          onChanged: (String value) {
            clientsBLoC.changeEmail(value);
          },
        ),
        SizedBox(
          height: 25,
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.streetAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.location_on_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: "Dirección",
            errorText: clientsBLoC.direccion.error,
          ),
          onChanged: (String value) {
            clientsBLoC.changeAddress(value);
          },
        ),
        SizedBox(
          height: 25,
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: "Teléfono",
            hintText: "Ej: 56987766554",
            errorText: clientsBLoC.fono.error,
          ),
          onChanged: (String value) {
            clientsBLoC.changePhone(value);
          },
        ),
        SizedBox(
          height: 25,
        ),
        buildClientTypeOptions(),
        clientsBLoC.isSelectedType
            ? SizedBox.shrink()
            : Container(
                margin: EdgeInsets.only(
                  left: 15.0,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Este campo es obligatorio.",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.red[700],
                  ),
                ),
              ),
        Row(
          children: [
            Flexible(
              child: ListTile(
                title: Text(
                  'Efectivo',
                  maxLines: 1,
                  style: TextStyle(fontSize: 18.5),
                  textAlign: TextAlign.left,
                ),
                leading: Radio(
                  value: "1",
                  groupValue: clientsBLoC.tipoPago.value,
                  onChanged: (value) {
                    clientsBLoC.changePayType(value);
                  },
                ),
                onTap: () {
                  clientsBLoC.changePayType("1");
                },
              ),
              flex: 1,
            ),
            Flexible(
              child: ListTile(
                title: Text('Crédito', style: TextStyle(fontSize: 18.5)),
                leading: Radio(
                  value: "2",
                  groupValue: clientsBLoC.tipoPago.value,
                  onChanged: (value) {
                    clientsBLoC.changePayType(value);
                  },
                ),
                onTap: () {
                  clientsBLoC.changePayType("2");
                },
              ),
              flex: 1,
            ),
          ],
        ),
        SizedBox(
          height: 18,
        ),
        clientsBLoC.tipoPago.value == "1"
            ? SizedBox.shrink()
            : buildCreditOptions(),
        clientsBLoC.isSelectedPayDays
            ? SizedBox.shrink()
            : Container(
                margin: EdgeInsets.only(
                  left: 15.0,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Este campo es obligatorio.",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.red[700],
                  ),
                ),
              ),
        SizedBox(
          height: 20.0,
        ),
        RoundedButton(
          size: size,
          onPressed: () {
            if (!clientsBLoC.isValid) {
              clientsBLoC.changeName(clientsBLoC.nombre.value);
              clientsBLoC.changeRUN(clientsBLoC.rut.value);
              clientsBLoC.changeEmail(clientsBLoC.correo.value);
              clientsBLoC.changeAddress(clientsBLoC.direccion.value);
              clientsBLoC.changePhone(clientsBLoC.fono.value);
            } else {
              onSubmit(context);
            }
          },
          buttonColor: Colors.green[600],
          buttonText: "Registrar",
        ),
      ],
    );
  }
}
