import 'package:arturo_bruna_app/presentation/splash/splash-large.dart';
import 'package:arturo_bruna_app/presentation/splash/splash-small.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/presentation/home/home_screen.dart';
import 'package:arturo_bruna_app/presentation/login/login.dart';
import 'package:arturo_bruna_app/presentation/splash/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashBLoC>(
      create: (_) => SplashBLoC(
        apiRepositoryInterface: context.watch<ApiRepositoryInterface>(),
        localRepositoryInterface: context.watch<LocalRepositoryInterface>(),
      )..init(context, _scaffoldKey),
      builder: (context, _) {
        final bloc = context.watch<SplashBLoC>();
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth >= 600.0) {
            print('constraints.maxWidth ${constraints.maxWidth}');
            return SplashLarge(
              scaffoldKey: _scaffoldKey,
              bloc: bloc,
            );
          } else {
            print('constraints.maxWidth ${constraints.maxWidth}');
            return SplashSmall(
              scaffoldKey: _scaffoldKey,
              bloc: bloc,
            );
          }
        });
      },
    );
  }
}
