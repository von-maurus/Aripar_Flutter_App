import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arturo_bruna_app/state-management-project/main_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/domain/model/user.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/home_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/splash/splash_screen.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/userprofile/user_bloc.dart';

//TODO: Mostrar opciones de configuracion (por el momento solo editar datos).
//TODO: Actualizar datos del usuario, imagen de perfil.

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
        (route) => false);
  }

  void onThemeUpdated(BuildContext context, bool isDark) {
    final profileBloc = Provider.of<ProfileBLoC>(context, listen: false);
    profileBloc.updateTheme(isDark);
    final mainBloc = context.read<MainBLoC>();
    mainBloc.loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = Provider.of<HomeBLoC>(context);
    final profileBloc = Provider.of<ProfileBLoC>(context);
    final user = homeBloc.usuario;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 6.0,
        title: Text(
          'Perfil',
          style: TextStyle(letterSpacing: 1.0, fontSize: 25.0),
        ),
        backgroundColor: Colors.orange[800],
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
                              color: Colors.white,
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.0),
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                'Vendedor',
                                style: TextStyle(
                                    color: Colors.white,
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
                        color: Colors.black87,
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

Widget body() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        flex: 0,
        child: Column(
          children: [
            // Container(
            //   margin: EdgeInsets.only(top: 15),
            //   // decoration: BoxDecoration(
            //   //     shape: BoxShape.circle, color: Colors.orange[700]),
            //   child: Padding(
            //     padding: const EdgeInsets.all(4.0),
            //     child: CircleAvatar(
            //       radius: 55.0,
            //       backgroundImage: NetworkImage(user.imagen),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10),
            // Text(
            //   user.nombre,
            //   style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white70,
            //       fontSize: 20.0),
            // ),
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20.0),
              // child: Card(
              //   color: Theme.of(context).canvasColor,
              //   child: Padding(
              //     padding: const EdgeInsets.all(25.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(
              //           'Información Personal',
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold, fontSize: 18.5),
              //           textAlign: TextAlign.center,
              //         ),
              //         const SizedBox(height: 25),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             Icon(Icons.person),
              //             Text(
              //               user.username,
              //               style: TextStyle(),
              //               textAlign: TextAlign.justify,
              //             ),
              //             Icon(Icons.phone_android),
              //             Text(
              //               user.fono,
              //             )
              //           ],
              //         ),
              //         // Row(
              //         //   children: [
              //         //     Text(
              //         //       'Modo Oscuro',
              //         //     ),
              //         //     Spacer(),
              //         //     ValueListenableBuilder<bool>(
              //         //       valueListenable:
              //         //           profileBloc.switchNotifier,
              //         //       builder: (_, value, __) {
              //         //         return Switch(
              //         //           value: value,
              //         //           onChanged: (val) =>
              //         //               onThemeUpdated(context, val),
              //         //           activeColor: Colors.purple,
              //         //         );
              //         //       },
              //         //     ),
              //         //   ],
              //         // ),
              //       ],
              //     ),
              //   ),
              // ),
            ),
            Spacer(),
            // Center(
            //   child: RaisedButton(
            //     onPressed: () => logout(context),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     color: Colors.blue[900],
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //       child: Text(
            //         'Cerrar Sesión',
            //         style: TextStyle(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      )
    ],
  );
}
