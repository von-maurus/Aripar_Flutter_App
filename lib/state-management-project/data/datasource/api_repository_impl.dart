import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:arturo_bruna_app/state-management-project/domain/model/user.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/preventa_cart.dart';
import 'package:arturo_bruna_app/state-management-project/domain/request/login_request.dart';
import 'package:arturo_bruna_app/state-management-project/domain/response/login_response.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/preventa_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/auth_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/client_exception.dart';
import 'package:arturo_bruna_app/state-management-project/domain/exception/product_exception.dart';

class ApiRepositoryImpl extends ApiRepositoryInterface {
  // Localhost URL
  // static const urlBase = 'http://192.168.1.86/sab-backend/';

  //Domain URL
  // static const urlBase = 'http://aripar.kuvesoft.cl/backend/'; //v1
  static const urlBase = 'http://test.kuvesoft.cl/backend/'; //v2 Test

  static const apiUrl = urlBase + 'web/index.php?r=';
  static const urlUserImage = urlBase + "assets/avatares/";
  static const urlProductImage = urlBase + "assets/productos/";
  Map<String, String> headers = {"Content-type": "application/json"};

  //Get user from token
  @override
  Future<Usuario> getUserFromToken(String token) async {
    const controller = 'usuarios/';
    final data = {'token': token};
    try {
      final response = await http
          .post(apiUrl + controller + 'is-logged-from-app',
              headers: headers, body: json.encode(data))
          .timeout(Duration(milliseconds: 10200), onTimeout: () {
        throw TimeoutException('Tiempo de espera agotado.');
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        return Usuario.fromJson(responseData['model']);
      }
      throw AuthException();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  //Login with email
  @override
  Future<LoginResponse> login(LoginRequest login) async {
    const controller = 'usuarios/';
    final data = {'email': login.email, 'password': login.password};
    try {
      final response = await http.Client()
          .post(apiUrl + controller + 'login-from-app',
              headers: headers, body: json.encode(data))
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Tiempo de espera agotado.');
      });
      final responseData = json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return LoginResponse(
            responseData['token'], Usuario.fromJson(responseData['model']));
      }
      throw AuthException();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  //Logout (erase local data)
  @override
  Future<void> logout(String token) async {
    print("Remover token del servidor");
    return;
  }

  //Get list of products
  @override
  Future<List<Producto>> getProducts() async {
    const controller = 'productos/';
    final response = await http.Client()
        .post(apiUrl + controller + 'index-activo', headers: headers);
    //Utilizando compute(function,variable), se mueve la ejecucion de la tarea a otro thread para que no existan "congelamientos" de la app.
    //Corre la funcion parseProducto en el "background".
    if (response.statusCode == 200) {
      return compute(parseProductos, response.body);
    }
    throw ProductException();
  }

  //Get  list of clients
  @override
  Future<List<Cliente>> getClientes() async {
    const controller = 'clientes/';
    final response = await http.Client()
        .post(apiUrl + controller + 'index-activo', headers: headers);
    if (response.statusCode == 200) {
      return compute(parseClientes, response.body);
    }
    throw ClientException(json.decode(response.body));
  }

  //Get products by name or code
  @override
  Future<List<Producto>> getProductByName(String query) async {
    const controller = 'productos/';
    final data = {'query': query};
    // print(data);
    final response = await http.Client()
        .post(apiUrl + controller + 'get-product-by-name-code',
            // headers: headers,
            body: data);
    // print(response.body);
    if (response.statusCode == 200) {
      return compute(parseProductos, response.body);
    }
    throw ProductException();
  }

  //Get clients by name, run or email
  @override
  Future<List<Cliente>> getClientByNameRunEmail(String query) async {
    const controller = 'clientes/';
    final data = {'query': query};
    // print(data);
    final response = await http.Client()
        .post(apiUrl + controller + 'get-client-by-name-run-email',
            // headers: headers,
            body: data);
    // print(response.body);
    if (response.statusCode == 200) {
      return compute(parseClientes, response.body);
    }
    throw ClientException(json.decode(response.body));
  }

  //Create a client
  @override
  Future<Cliente> createCliente(Cliente client) async {
    const controller = 'clientes/';
    final data = client.createToJson();
    final dataEncode = json.encode(data);
    final response = await http.Client()
        .post(apiUrl + controller + 'create-from-app',
            headers: headers, body: dataEncode)
        .timeout(Duration(seconds: 10), onTimeout: () {
      throw TimeoutException(
          'Tiempo de espera agotado, su conexión es deficiente.');
    });
    print('Respuesta sin decode: ${response.body}');
    if (response.statusCode == 201) {
      return parseClient(response.body);
    }
    throw ClientException(json.decode(response.body));
  }

  //Create a pre-sale with a list of products, a total price (with taxes)
  //client data like ID, pay type and credit days and the user token
  @override
  Future<dynamic> createPreSale(List<PreSaleCart> preSaleList, int clientId,
      int payType, int total, String token, int diasCuota) async {
    const controller = 'ventas/';
    final jsonPreSaleList = preSaleList.map((e) => e.toJson()).toList();
    final data = {
      "listaPreVenta": jsonPreSaleList,
      "idClient": clientId,
      "tipoPago": payType,
      "total": total,
      "token": token,
      "diasCuota": diasCuota,
    };
    final response = await http.Client()
        .post(apiUrl + controller + 'create',
            headers: headers, body: jsonEncode(data))
        .timeout(Duration(seconds: 10), onTimeout: () {
      throw TimeoutException('Tiempo de espera agotado, inténtelo nuevamente.');
    });
    if (response.statusCode == 200) {
      final decodeResponse = jsonDecode(response.body);
      print('Respuesta Status 200: $decodeResponse');
      return decodeResponse['response'];
    } else if (response.statusCode == 500) {
      final decodeResponse = jsonDecode(response.body);
      print('Respuesta Status 500: $decodeResponse');
      throw PreSaleException(decodeResponse['response']);
    } else {
      final decodeResponse = jsonDecode(response.body);
      print('Respuesta Status 401: $decodeResponse');
      throw Exception();
    }
  }
}

Cliente parseClient(String responseBody) {
  return Cliente.fromJson(json.decode(responseBody)['model']);
}

List<Producto> parseProductos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Producto>((json) => Producto.fromJson(json)).toList();
}

List<Cliente> parseClientes(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Cliente>((json) => Cliente.fromJson(json)).toList();
}
