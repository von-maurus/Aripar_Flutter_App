import 'package:arturo_bruna_app/presentation/home/home_screen.dart';
import 'package:arturo_bruna_app/presentation/login/login.dart';
import 'package:arturo_bruna_app/presentation/splash/splash_bloc.dart';
import 'package:flutter/material.dart';

class SplashSmall extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final SplashBLoC bloc;

  const SplashSmall({Key key, this.scaffoldKey, this.bloc}) : super(key: key);

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
              !bloc.isTimeoutException
                  ? CircularProgressIndicator(strokeWidth: 4)
                  : RaisedButton(
                      color: Colors.blue,
                      shape: StadiumBorder(),
                      child: Text(
                        "Reintentar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      splashColor: Colors.green,
                      elevation: 5.0,
                      onPressed: () {
                        retry(context, scaffoldKey);
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> retry(
      BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) async {
    final result = await bloc.validateSession(_scaffoldKey);
    await Future.delayed(Duration(milliseconds: 1200));
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
}
