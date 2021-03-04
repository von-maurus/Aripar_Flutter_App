import 'package:arturo_bruna_app/domain/model/user.dart';

class LoginResponse {
  const LoginResponse(this.token, this.usuario);

  final String token;
  final Usuario usuario;
}
