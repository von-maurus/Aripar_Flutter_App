import 'package:arturo_bruna_app/domain/model/user.dart';

abstract class LocalRepositoryInterface {
  Future<String> getToken();
  Future<void> clearData();
  Future<Usuario> saveUser(Usuario usuario);
  Future<Usuario> getUser();
  Future<String> saveToken(String token);
  Future<void> saveTheme(bool theme);
  Future<bool> getTheme();
}
