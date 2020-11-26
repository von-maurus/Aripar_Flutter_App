import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/validation_item.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/client_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum ClientsState {
  loading,
  initial,
}

class ClientesBLoC extends ChangeNotifier {
  final ApiRepositoryInterface apiRepositoryInterface;
  final LocalRepositoryInterface localRepositoryInterface;

  ClientesBLoC({this.apiRepositoryInterface, this.localRepositoryInterface});

  //ClientBloc Variables
  List<Cliente> clientList = <Cliente>[];
  List<Cliente> clientsByName = <Cliente>[];
  List<Cliente> historial = [];
  Cliente client = new Cliente();
  var clientsState = ClientsState.initial;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##.###.###-#', filter: {"#": RegExp(r'[0-9]|k')});
  var response;
  double cardHeight = 180;
  int numDiasCuota = 1;
  int clientType = 1;

  //Form Variables
  ValidationItem _nombre = ValidationItem(null, null);
  ValidationItem _rut = ValidationItem(null, null);
  ValidationItem _correo = ValidationItem(null, null);
  ValidationItem _direccion = ValidationItem(null, null);
  ValidationItem _fono = ValidationItem(null, null);
  ValidationItem _tipoPago = ValidationItem("1", null);
  ValidationItem _numCuotas = ValidationItem(null, null);
  ValidationItem _tipo = ValidationItem(null, null);

  //Getters
  ValidationItem get nombre => _nombre;
  ValidationItem get rut => _rut;
  ValidationItem get correo => _correo;
  ValidationItem get direccion => _direccion;
  ValidationItem get fono => _fono;
  ValidationItem get tipoPago => _tipoPago;
  ValidationItem get numCuotas => _numCuotas;
  ValidationItem get tipo => _tipo;

  void clearFields() {
    _nombre = ValidationItem(null, null);
    _rut = ValidationItem(null, null);
    _correo = ValidationItem(null, null);
    _direccion = ValidationItem(null, null);
    _fono = ValidationItem(null, null);
    _tipoPago = ValidationItem("1", null);
    _numCuotas = ValidationItem(null, null);
    _tipo = ValidationItem(null, null);
    maskFormatter.clear();
    numDiasCuota = 1;
    clientType = 1;
    notifyListeners();
  }

  bool get isValid {
    if (_tipoPago.value == "1") {
      if (_nombre.value != null &&
          _rut.value != null &&
          _correo.value != null &&
          _direccion.value != null &&
          _fono.value != null) {
        return true;
      } else {
        return false;
      }
    } else {
      if (_nombre.value != null &&
          _rut.value != null &&
          _correo.value != null &&
          _direccion.value != null &&
          _fono.value != null &&
          _numCuotas.value != null) {
        return true;
      } else {
        return false;
      }
    }
  }

  //Setters
  void changeType(String type) {
    if (type == '' || type == null) {
      _nombre = ValidationItem(null, "Este campo es obligatorio.");
    } else {
      _tipo = ValidationItem(type, null);
      clientType = int.parse(type);
    }
    notifyListeners();
  }

  void changeName(String name) {
    if (name == '' || name == null) {
      _nombre = ValidationItem(null, "Este campo es obligatorio.");
    } else if (name.length < 3) {
      _nombre = ValidationItem(null, "Debe contener al menos 3 caractéres.");
    } else {
      _nombre = ValidationItem(name, null);
    }
    notifyListeners();
  }

  void changeRUN(String run) {
    run = maskFormatter.getUnmaskedText();
    if (run == null || run == '') {
      _rut = ValidationItem(null, "Este campo es obligatorio.");
    } else if (run.length < 8) {
      _rut = ValidationItem(null, "El RUT es incorrecto.");
    } else {
      if (validateRUT(run)) {
        _rut = ValidationItem(run, null);
      } else {
        _rut = ValidationItem(null, "RUT incorrecto, vuelva a intentar.");
      }
    }
    notifyListeners();
  }

  bool validateRUT(String run) {
    // Aislar Cuerpo y Dígito Verificador
    String body;
    var dv;
    if (run.length == 8) {
      body = run.substring(0, 7);
      dv = run.substring(7).toUpperCase();
    } else {
      body = run.substring(0, 8);
      dv = run.substring(8).toUpperCase();
    }

    //Calcular DV
    var suma = 0;
    int multiple = 2;

    // Para cada dígito del Cuerpo
    for (var i = 1; i <= body.length; i++) {
      // Obtener su Producto con el Múltiplo Correspondiente
      var index = multiple * int.parse(run[body.length - i]);
      // Sumar al Contador General
      suma = suma + index;

      // Consolidar Múltiplo dentro del rango [2,7]
      if (multiple < 7) {
        multiple = multiple + 1;
      } else {
        multiple = 2;
      }
    }
    // Calcular Dígito Verificador en base al Módulo 11
    var dvEsperado = 11 - (suma % 11);
    // Casos Especiales (0 y K)
    dv = (dv == 'K') ? 10 : dv;
    dv = (dv == '0') ? 11 : dv;

    // Validar que el Cuerpo coincide con su Dígito Verificador
    if (dvEsperado.toString() != dv.toString()) {
      return false;
    } else {
      return true;
    }
  }

  void changeEmail(String email) {
    if (email == null || email == '') {
      _correo = ValidationItem(null, "Este campo es obligatorio.");
    } else {
      _correo = ValidationItem(email, null);
    }
    notifyListeners();
  }

  void changeAddress(String address) {
    if (address == null || address == '') {
      _direccion = ValidationItem(null, "Este campo es obligatorio.");
    } else {
      _direccion = ValidationItem(address, null);
    }
    notifyListeners();
  }

  void changePhone(String phone) {
    if (phone == null || phone == '') {
      _fono = ValidationItem(null, "Este campo es obligatorio.");
    } else {
      _fono = ValidationItem(phone, null);
    }
    notifyListeners();
  }

  void changeNumCuotas(String numCuotas) {
    if (numCuotas == null || numCuotas == '') {
      _numCuotas = ValidationItem(null, "Este campo es obligatorio.");
    } else {
      numDiasCuota = int.parse(numCuotas);
      _numCuotas = ValidationItem(numCuotas, null);
    }
    notifyListeners();
  }

  void changePayType(String clientPayType) {
    _tipoPago = ValidationItem(clientPayType, null);
    if (clientPayType == "2") {
      _numCuotas = ValidationItem("1", null);
    } else {
      _numCuotas = ValidationItem(null, null);
    }
    notifyListeners();
  }

  Future<bool> submitData() async {
    //  Crear un objeto Cliente
    if (isValid) {
      try {
        Cliente client = new Cliente();
        client.nombre = _nombre.value;
        client.rut = _rut.value;
        client.correo = _correo.value;
        client.direccion = _direccion.value;
        client.fono = _fono.value;
        client.numerocuotas =
            _tipoPago.value == "1" ? null : int.parse(_numCuotas.value);
        client.tipopago = int.parse(_tipoPago.value);
        client.tipo = int.parse(_tipo.value);
        clientsState = ClientsState.loading;
        notifyListeners();
        final result = await apiRepositoryInterface.createCliente(client);
        print('resultado de create $result');
        if (result != null) {
          clientList.insert(0, result);
        }
        clientsState = ClientsState.initial;
        notifyListeners();
        return true;
      } on ClientException catch (_) {
        clientsState = ClientsState.initial;
        notifyListeners();
        return false;
      }
    } else {
      return false;
    }
  }

  void loadClients() async {
    try {
      clientsState = ClientsState.loading;
      notifyListeners();
      final result = await apiRepositoryInterface.getClientes();
      clientList = result;
      print('LISTA CON CLIENTES ${clientList.length}');
      clientsState = ClientsState.initial;
      notifyListeners();
    } on ClientException catch (_) {
      clientsState = ClientsState.initial;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> getClientByNameRunEmail(String query) async {
    try {
      // productsState = ProductsState.loading;
      // notifyListeners();
      final result =
          await apiRepositoryInterface.getClientByNameRunEmail(query);
      clientsByName = result;
      // productsState = ProductsState.initial;
      // notifyListeners();
    } on ClientException catch (e) {
      print(e);
      // productsState = ProductsState.initial;
      // notifyListeners();
    }
  }

  Future<void> insertClient(Cliente client) async {
    try {
      clientsState = ClientsState.loading;
      notifyListeners();
      final result = await apiRepositoryInterface.createCliente(client);
      print('resultado de create $result');
      print('LISTA ANTES ${clientList.length}');
      if (result != null) {
        clientList.insert(0, result);
      }
      print('LISTA DESPUES ${clientList.length}');
      clientsState = ClientsState.initial;
      notifyListeners();
    } on ClientException catch (_) {
      clientsState = ClientsState.initial;
      notifyListeners();
    }
  }
}
