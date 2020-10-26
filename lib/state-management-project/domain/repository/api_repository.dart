import 'package:arturo_bruna_app/state-management-project/domain/model/cliente.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/preventa_cart.dart';
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

//  Create PreSale: 1-Inserta la Venta 2-Crear lineasVenta 3-Opcional:crear cuota
  Future<dynamic> createPreSale(List<PreSaleCart> preSaleList, int clientId,
      int payType, int total, String token, int diasCuota);
}
