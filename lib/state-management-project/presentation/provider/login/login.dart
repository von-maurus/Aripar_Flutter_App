import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/login/logo.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/custom_input.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/rounded_button.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/login/login_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/home_screen.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/login/background.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/login/bottom_labels_login.dart';

class LoginPage extends StatelessWidget {
  LoginPage._();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginBLoC(
        apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
        localRepositoryInterface: context.read<LocalRepositoryInterface>(),
      ),
      builder: (_, __) => LoginPage._(),
    );
  }

  void login(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final bloc = context.read<LoginBLoC>();
    final result = await bloc.login();
    if (result) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage.init(context),
        ),
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 900),
          content: Text('Email o Contraseña incorrectos.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bloc = context.watch<LoginBLoC>();
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: size.height,
              child: Background(
                size: size,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Logo(
                          size: size,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: size.height * 0.02),
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.051),
                          child: Column(
                            children: <Widget>[
                              CustomInput(
                                size: size,
                                prefixIcon: Icon(Icons.email),
                                hintText: 'Email',
                                controller: bloc.emailTextController,
                                textInputType: TextInputType.emailAddress,
                              ),
                              CustomInput(
                                  isObscure: true,
                                  size: size,
                                  prefixIcon: Icon(Icons.vpn_key),
                                  hintText: 'Contraseña',
                                  controller: bloc.passwordTextController),
                              RoundedButton(
                                size: size,
                                buttonText: "Iniciar sesión",
                                onPressed: () => login(context),
                                buttonColor: Colors.orange[500],
                                buttonTextColor: Colors.black,
                              )
                            ],
                          ),
                        ),
                        BottomLabels(
                          size: size,
                        )
                      ],
                    ),
                  ),
                ),
              )),
          if (bloc.loginState == LoginState.loading)
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
