import 'package:arturo_bruna_app/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/presentation/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RecoverPasswordScreen extends StatelessWidget {
  RecoverPasswordScreen._();

  static Widget init(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));

    return ChangeNotifierProvider(
      create: (_) => LoginBLoC(
        apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
      ),
      builder: (_, __) => RecoverPasswordScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    // Size size = MediaQuery.of(context).size;
    // final bloc = context.watch<LoginBLoC>();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        print('constraints.maxWidth ${constraints.maxWidth}');
        if (constraints.maxWidth >= 600.0) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }
}
