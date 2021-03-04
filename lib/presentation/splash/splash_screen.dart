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
  SplashScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashBLoC(
        apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
        localRepositoryInterface: context.read<LocalRepositoryInterface>(),
      ),
      builder: (_, __) => SplashScreen._(),
    );
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _init() async {
    final bloc = context.read<SplashBLoC>();
    final result = await bloc.validateSession(_scaffoldKey);
    await Future.delayed(Duration(milliseconds: 1100));
    if (result) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage.init(context),
        ),
      );
    } else {
      if (!bloc.isTimeoutException) {
        await Future.delayed(Duration(milliseconds: 2300));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginPage.init(context),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _init();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
