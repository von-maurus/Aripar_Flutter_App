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
  Cliente client = new Cliente();
  var clientsState = ClientsState.initial;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##.###.###-#', filter: {"#": RegExp(r'[0-9]|k')});
  var response;
  double cardHeight = 180;

  //Form Variables
  ValidationItem _nombre = ValidationItem(null, null);
  ValidationItem _rut = ValidationItem(null, null);
  ValidationItem _correo = ValidationItem(null, null);
  ValidationItem _direccion = ValidationItem(null, null);
  ValidationItem _fono = ValidationItem(null, null);
  ValidationItem _tipoPago = ValidationItem("1", null);
  ValidationItem _numCuotas = ValidationItem(null, null);

  //Getters
  ValidationItem get nombre => _nombre;

  ValidationItem get rut => _rut;

  ValidationItem get correo => _correo;

  ValidationItem get direccion => _direccion;

  ValidationItem get fono => _fono;

  ValidationItem get tipoPago => _tipoPago;

  ValidationItem get numCuotas => _numCuotas;

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
    } else {
      _rut = ValidationItem(run, null);
    }
    notifyListeners();
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
      _numCuotas = ValidationItem(numCuotas, null);
    }
    notifyListeners();
  }

  void changePayType(String clientPayType) {
    _tipoPago = ValidationItem(clientPayType, null);
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
        client.numerocuotas = int.parse(_numCuotas.value);
        client.tipopago = int.parse(_tipoPago.value);
        clientsState = ClientsState.loading;
        print('Lista antes del notify ${clientList.length}');
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
