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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth >= 600.0) {
        print('constraints.maxWidth ${constraints.maxWidth}');
        return _SplashLarge(
          scaffoldKey: _scaffoldKey,
        );
      } else {
        print('constraints.maxWidth ${constraints.maxWidth}');
        return _SplashSmall(
          scaffoldKey: _scaffoldKey,
        );
      }
    });
  }
}

class _SplashLarge extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _SplashLarge({Key key, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.blue[800],
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.height * 0.3,
                backgroundColor: Colors.blue[900],
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/images/aripar_white_logo.png',
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              SizedBox(
                width:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? MediaQuery.of(context).size.width * 0.07
                        : MediaQuery.of(context).size.width * 0.1,
                height:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? MediaQuery.of(context).size.width * 0.07
                        : MediaQuery.of(context).size.width * 0.1,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue[900],
                  strokeWidth: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashSmall extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _SplashSmall({Key key, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.blue[800],
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 90.0,
                backgroundColor: Colors.blue[900],
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/images/aripar_white_logo.png',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
