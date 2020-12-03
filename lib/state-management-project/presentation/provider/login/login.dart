import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/rounded_button.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/custom_form_input.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/login/logo.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
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

  String validateEmail(String value, LoginBLoC loginBLoC) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null) {
      loginBLoC.isValidEmail = false;
      return 'Ingrese un correo válido\n';
    } else {
      loginBLoC.isValidEmail = true;
      return null;
    }
  }

  String validatePassword(String value, LoginBLoC loginBLoC) {
    if (value == '') {
      loginBLoC.isValidPassword = false;
      return 'Este campo es obligatorio\n';
    } else {
      loginBLoC.isValidPassword = true;
      return null;
    }
  }

  Widget buildLoginSmall(Size size, LoginBLoC bloc, BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[700],
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: size.height,
              child: Background(
                size: size,
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
                              right: 0,
                              bottom: 0,
                              left: 0,
                              top: 0,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                final response = validateEmail(value, bloc);
                                return response;
                              },
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
                              right: 0,
                              bottom: 0,
                              left: 0,
                              top: 0,
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
                              validator: (value) {
                                final response = validatePassword(value, bloc);
                                return response;
                              },
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
                        fontSizeTerms: 15.5,
                        indent: 10,
                        endIndent: 10,
                        size: size,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (bloc.loginState == LoginState.loading)
              Container(
                color: Colors.black45,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget buildLoginLarge(Size size, LoginBLoC bloc, BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[900],
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
                width: double.infinity,
                height: size.height,
                child: Background(
                  size: size,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Logo(
                          size: size,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: size.height * 0.02),
                          padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? size.width * 0.09
                                  : size.width * 0.075,
                              vertical: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? size.width * 0.009
                                  : size.width * 0.005),
                          child: Column(
                            children: <Widget>[
                              CustomFormInput(
                                textFormStyle: TextStyle(fontSize: 28.0),
                                hintStyle: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.landscape
                                            ? 30.0
                                            : 27.0),
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  final response = validateEmail(value, bloc);
                                  return response;
                                },
                                textInputAction: TextInputAction.next,
                                focusNode: _focusNodeEmail,
                                size: size,
                                prefixIcon: Icon(
                                  Icons.email,
                                  size: 50,
                                ),
                                hintText: '\t\tEmail',
                                controller: bloc.emailTextController,
                                textInputType: TextInputType.emailAddress,
                                function: (value) {
                                  _focusNodePassword.requestFocus();
                                },
                                top: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? size.height * 0.02
                                    : size.height * 0.015,
                                left: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? size.height * 0.025
                                    : size.height * 0.02,
                                bottom: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? size.height * 0.03
                                    : size.height * 0.018,
                                right: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? size.height * 0.03
                                    : size.height * 0.009,
                              ),
                              CustomFormInput(
                                textFormStyle: TextStyle(fontSize: 28.0),
                                left: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? size.height * 0.025
                                    : size.height * 0.02,
                                top: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? size.height * 0.02
                                    : size.height * 0.012,
                                bottom: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? size.height * 0.03
                                    : size.height * 0.018,
                                right: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? size.height * 0.03
                                    : size.height * 0.02,
                                hintStyle: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).orientation ==
                                              Orientation.landscape
                                          ? 30.0
                                          : 27.0,
                                ),
                                suffixWidget: IconButton(
                                  icon: Icon(
                                    bloc.isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 45,
                                  ),
                                  onPressed: () {
                                    bloc.showHidePassword();
                                  },
                                ),
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  final response =
                                      validatePassword(value, bloc);
                                  return response;
                                },
                                textInputAction: TextInputAction.done,
                                focusNode: _focusNodePassword,
                                isObscure: bloc.isObscure,
                                size: size,
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  size: 50,
                                ),
                                hintText: '\t\tContraseña',
                                controller: bloc.passwordTextController,
                                function: (value) {
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                              RoundedButton(
                                textFontSize:
                                    MediaQuery.of(context).orientation ==
                                            Orientation.landscape
                                        ? 40.0
                                        : 34.0,
                                height: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? 85.0
                                    : 75.0,
                                size: size,
                                buttonText: "Iniciar sesión",
                                onPressed: () => login(context),
                                buttonColor: Colors.orange[500],
                                buttonTextColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        BottomLabels(
                          fontSizeContact: 18.0,
                          fontSizeNotAccount: 18.0,
                          sizeForgotPass: 22.0,
                          indent: 22.0,
                          endIndent: 22.0,
                          size: size,
                          fontSizeTerms: 19.0,
                        ),
                      ],
                    ),
                  ),
                )),
            if (bloc.loginState == LoginState.loading)
              Container(
                color: Colors.black45,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    backgroundColor: Colors.black,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bloc = context.watch<LoginBLoC>();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        print('constraints.maxWidth ${constraints.maxWidth}');
        if (constraints.maxWidth >= 600.0) {
          return buildLoginLarge(size, bloc, context);
        } else {
          return buildLoginSmall(size, bloc, context);
        }
      },
    );
  }
}
