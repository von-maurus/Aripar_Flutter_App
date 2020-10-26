import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/login/logo.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/rounded_button.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/custom_form_input.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/login/login_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/home_screen.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/login/background.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/login/bottom_labels_login.dart';

class LoginPage extends StatelessWidget {
  LoginPage._();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _focusNodeEmail = new FocusNode();
  final FocusNode _focusNodePassword = new FocusNode();

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
    final result = await bloc.login(_scaffoldKey);
    if (result) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage.init(context),
        ),
      );
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Ingrese un correo válido';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value == '') {
      return 'Este campo es obligatorio';
    } else if (value.length < 5)
      return 'Cinco o más caracteres';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bloc = context.watch<LoginBLoC>();
    return Scaffold(
      backgroundColor: Colors.blue,
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
                              CustomFormInput(
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: validateEmail,
                                textInputAction: TextInputAction.next,
                                focusNode: _focusNodeEmail,
                                size: size,
                                prefixIcon: Icon(Icons.email),
                                hintText: 'Email',
                                controller: bloc.emailTextController,
                                textInputType: TextInputType.emailAddress,
                                function: (value) {
                                  _focusNodePassword.requestFocus();
                                },
                              ),
                              CustomFormInput(
                                suffixWidget: IconButton(
                                  icon: Icon(bloc.isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    bloc.showHidePassword();
                                  },
                                ),
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: validatePassword,
                                textInputAction: TextInputAction.done,
                                focusNode: _focusNodePassword,
                                isObscure: bloc.isObscure,
                                size: size,
                                prefixIcon: Icon(Icons.vpn_key),
                                hintText: 'Contraseña',
                                controller: bloc.passwordTextController,
                                function: (value) {
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                              RoundedButton(
                                size: size,
                                buttonText: "Iniciar sesión",
                                onPressed: () => login(context),
                                buttonColor: Colors.orange[500],
                                buttonTextColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        BottomLabels(
                          size: size,
                        ),
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
