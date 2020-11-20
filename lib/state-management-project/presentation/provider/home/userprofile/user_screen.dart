import 'package:arturo_bruna_app/state-management-project/presentation/common/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/state-management-project/main_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/user.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/home_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/splash/splash_screen.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/userprofile/user_bloc.dart';

class UserScreen extends StatelessWidget {
  UserScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileBLoC(
        apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
        localRepositoryInterface: context.read<LocalRepositoryInterface>(),
      )..loadTheme(),
      builder: (_, __) => UserScreen._(),
    );
  }

  Future<void> logout(BuildContext context) async {
    final profileBloc = Provider.of<ProfileBLoC>(context, listen: false);
    await profileBloc.logOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => SplashScreen.init(context),
      ),
      (route) => false,
    );
  }

  void onThemeUpdated(BuildContext context, bool isDark) {
    final profileBloc = Provider.of<ProfileBLoC>(context, listen: false);
    profileBloc.updateTheme(isDark);
    final mainBloc = context.read<MainBLoC>();
    mainBloc.loadTheme();
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        content: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            "¿Desea cerrar sesión?",
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          FlatButton(
            child: Text("Si"),
            shape: StadiumBorder(),
            onPressed: () async {
              await logout(context);
            },
          ),
          FlatButton(
            shape: StadiumBorder(),
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = Provider.of<HomeBLoC>(context);
    // final profileBloc = Provider.of<ProfileBLoC>(context);
    final user = homeBloc.usuario;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
            heroTag: "btnLogout",
            backgroundColor: Colors.red[600],
            child: Icon(Icons.logout),
            elevation: 10,
            onPressed: () => _showMyDialog(context)),
        appBar: AppBar(
          centerTitle: true,
          elevation: 6.0,
          title: Text(
            'Perfil',
            style: TextStyle(letterSpacing: 1.0, fontSize: 25.0),
          ),
          backgroundColor: Colors.blue[900],
        ),
        body: user?.imagen != null
            ? ListView(
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 15),
                              // decoration: BoxDecoration(
                              //     shape: BoxShape.circle, color: Colors.orange[700]),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  radius: 65.0,
                                  backgroundImage: NetworkImage(user.imagen),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          Text(
                            user.nombre,
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          user.tipo == 1
                              ? Text(
                                  'Administrador',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.0),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  'Vendedor',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.0),
                                  textAlign: TextAlign.center,
                                ),
                          _UserInfo(
                            user: user,
                          )
                        ],
                      )
                    ],
                  )
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  final Usuario user;
  const _UserInfo({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Card(
            color: Colors.white54,
            shadowColor: Colors.black,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Información Personal",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                    thickness: 2,
                  ),
                  Container(
                      child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Usuario"),
                        subtitle: Text(user.username),
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text("Correo"),
                        subtitle: Text(user.correo),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text("Teléfono"),
                        subtitle: Text('+' + user.fono),
                      ),
                      ListTile(
                        leading: Icon(Icons.monetization_on),
                        title: Text("Comisión"),
                        subtitle: Text(user.comision.toString() + '%'),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
