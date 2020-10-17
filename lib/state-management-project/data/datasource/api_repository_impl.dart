import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:arturo_bruna_app/state-management-project/domain/model/user.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/domain/request/login_request.dart';
import 'package:arturo_bruna_app/state-management-project/domain/response/login_response.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/auth_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/client_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/product_exception.dart';

//Implementacion de los servicios para el Backend
//en ApiRepositoryInterface (..domain/repository/) van estas funciones
class ApiRepositoryImpl extends ApiRepositoryInterface {
  static const urlBase = 'http://192.168.1.86/sab-backend/';
  static const apiUrl = urlBase + 'web/index.php?r=';
  static const urlUserImage = urlBase + "assets/avatares/";
  static const urlProductImage = urlBase + "assets/productos/";
  Map<String, String> headers = {"content-type": "application/json"};

  @override
  Future<Usuario> getUserFromToken(String token) async {
    const controller = 'usuarios/';
    final data = {'token': token};
    final response = await http.post(apiUrl + controller + 'is-logged-from-app',
        headers: headers, body: json.encode(data));
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return Usuario(
          id: responseData['model']['id'],
          nombre: responseData['model']['nombre'],
          username: responseData['model']['username'],
          correo: responseData['model']['correo'],
          tipo: responseData['model']['tipo'],
          fono: responseData['model']['fono'],
          comision: responseData['model']['comision'],
          imagen: urlUserImage + responseData['model']['imagen'],
          estado: responseData['model']['estado']);
    }
    throw AuthException();
  }

  @override
  Future<LoginResponse> login(LoginRequest login) async {
    const controller = 'usuarios/';
    final data = {'email': login.email, 'password': login.password};
    final response = await http.post(apiUrl + controller + 'login-from-app',
        headers: headers, body: json.encode(data));
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return LoginResponse(
          responseData['token'],
          Usuario(
              id: responseData['model']['id'],
              nombre: responseData['model']['nombre'],
              username: responseData['model']['username'],
              correo: responseData['model']['correo'],
              tipo: responseData['model']['tipo'],
              fono: responseData['model']['fono'],
              comision: responseData['model']['comision'],
              imagen: urlUserImage + responseData['model']['imagen'],
              estado: responseData['model']['estado']));
    }
    throw AuthException();
  }

  @override
  Future<void> logout(String token) async {
    print("Remover token del servidor");
    return;
  }

  @override
  Future<List<Producto>> getProducts() async {
    const controller = 'productos/';
    final response = await http.Client()
        .post(apiUrl + controller + 'index', headers: headers);
    //Utilizando compute(function,variable), se mueve la ejecucion de la tarea a otro thread para que no existan "congelamientos" de la app.
    //Corre la funcion parseProducto en el "background".
    if (response.statusCode == 200) {
      return compute(parseProductos, response.body);
    }
    throw ProductException();
  }

  @override
  Future<List<Cliente>> getClientes() async {
    const controller = 'clientes/';
    final response = await http.Client()
        .post(apiUrl + controller + 'index', headers: headers);
    if (response.statusCode == 200) {
      return compute(parseClientes, response.body);
    }
    throw ClientException();
  }

  @override
  Future<Cliente> createCliente(Cliente cliente) {
    // TODO: implement createCliente
    throw UnimplementedError();
  }
}

List<Producto> parseProductos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Producto>((json) => Producto.fromJson(json)).toList();
}

List<Cliente> parseClientes(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Cliente>((json) => Cliente.fromJson(json)).toList();
}