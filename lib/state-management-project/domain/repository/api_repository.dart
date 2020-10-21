import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/product.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/user.dart';
import 'package:arturo_bruna_app/state-management-project/domain/request/login_request.dart';
import 'package:arturo_bruna_app/state-management-project/domain/response/login_response.dart';

abstract class ApiRepositoryInterface {
  Future<Usuario> getUserFromToken(String token);

  Future<LoginResponse> login(LoginRequest login);

  Future<void> logout(String token);

  Future<List<Producto>> getProducts();

  Future<List<Producto>> getProductByName(String query);

  Future<List<Cliente>> getClientes();

  Future<List<Cliente>> getClientByNameRunEmail(String query);
//  Crear Clientes
  Future<Cliente> createCliente(Cliente cliente);

//  Crear preventa: Son dos Inserts
//    1- Venta: {fecha,montototal,tipopago,comision,estado,idCliente,idUsuario}

//    2- LineaVenta: {precio(precioVenta),valorTotal(cantidad*precioVenta), cantidad, idProducto, idVenta})
//  Actualizar datos del usuario (id, {nombre, correo, username, fono, imagen})
}
