import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/splash/splash_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/login/login.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/home_screen.dart';

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
  void _init() async {
    await Future.delayed(Duration(milliseconds: 900));
    final bloc = context.read<SplashBLoC>();
    final result = await bloc.validateSession();
    if (result) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage.init(context),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginPage.init(context),
        ),
      );
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
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 75.0,
              backgroundColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/images/aripar_white_logo.png',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
