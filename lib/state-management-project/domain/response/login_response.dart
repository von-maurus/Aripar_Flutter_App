import 'package:arturo_bruna_app/state-management-project/domain/model/user.dart';

class LoginResponse {
  const LoginResponse(this.token, this.usuario);
  final String token;
  final Usuario usuario;
}
