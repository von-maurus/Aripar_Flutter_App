import 'package:arturo_bruna_app/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/presentation/common/custom_form_input.dart';
import 'package:arturo_bruna_app/presentation/common/rounded_button.dart';
import 'package:arturo_bruna_app/presentation/home/home_screen.dart';
import 'package:arturo_bruna_app/presentation/login/background.dart';
import 'package:arturo_bruna_app/presentation/login/bottom_labels_login.dart';
import 'package:arturo_bruna_app/presentation/login/login_bloc.dart';
import 'package:arturo_bruna_app/presentation/login/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage._();

  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bloc = context.watch<LoginBLoC>();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        print('constraints.maxWidth ${constraints.maxWidth}');
        if (constraints.maxWidth >= 600.0) {
          return buildLargeLogin(size, bloc, context);
        } else {
          return buildSmallLogin(size, bloc, context);
        }
      },
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

  Widget buildSmallLogin(Size size, LoginBLoC bloc, BuildContext context) {
    return SafeArea(
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          backgroundColor: Colors.blue[700],
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
                                  final response =
                                      validatePassword(value, bloc);
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
      ),
    );
  }

  Widget buildLargeLogin(Size size, LoginBLoC bloc, BuildContext context) {
    return SafeArea(
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          backgroundColor: Colors.blue[700],
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
                                horizontal:
                                    MediaQuery.of(context).orientation ==
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
                                  textFormStyle: TextStyle(fontSize: 25.5),
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _focusNodeEmail,
                                  size: size,
                                  hintText: '\t\tEmail',
                                  controller: bloc.emailTextController,
                                  textInputType: TextInputType.emailAddress,
                                  function: (value) {
                                    _focusNodePassword.requestFocus();
                                  },
                                  prefixIcon: Icon(
                                    Icons.email,
                                    size: 50,
                                  ),
                                  validator: (value) {
                                    final response = validateEmail(value, bloc);
                                    return response;
                                  },
                                  hintStyle: TextStyle(fontSize: 25.0),
                                  top: size.height * 0.01,
                                  left: size.height * 0.02,
                                  bottom: size.height * 0.010,
                                  right: size.height * 0.009,
                                ),
                                CustomFormInput(
                                  textFormStyle: TextStyle(fontSize: 25.5),
                                  left: size.height * 0.02,
                                  top: size.height * 0.01,
                                  bottom: size.height * 0.010,
                                  right: size.height * 0.02,
                                  hintText: '\t\tContraseña',
                                  controller: bloc.passwordTextController,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.done,
                                  focusNode: _focusNodePassword,
                                  isObscure: bloc.isObscure,
                                  size: size,
                                  validator: (value) {
                                    final response =
                                        validatePassword(value, bloc);
                                    return response;
                                  },
                                  hintStyle: TextStyle(
                                    fontSize: 25.0,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    size: 50,
                                  ),
                                  suffixWidget: IconButton(
                                    icon: Icon(
                                      bloc.isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 35.0,
                                    ),
                                    onPressed: () {
                                      bloc.showHidePassword();
                                    },
                                  ),
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
                                    textFontSize: 30.0,
                                    height: 70.0),
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
      ),
    );
  }
}
