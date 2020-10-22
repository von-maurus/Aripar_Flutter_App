import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/clientes_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/main_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/data/datasource/api_repository_impl.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/data/datasource/local_repository_impl.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/splash/splash_screen.dart';

class MainProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiRepositoryInterface>(
          create: (c) => ApiRepositoryImpl(),
        ),
        Provider<LocalRepositoryInterface>(
          create: (_) => LocalRepositoryImpl(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            return MainBLoC(
                localRepositoryInterface: _.read<LocalRepositoryInterface>())
              ..loadTheme();
          },
        ),
        ChangeNotifierProvider(
          create: (context) => ClientesBLoC(
              apiRepositoryInterface: context.read<ApiRepositoryInterface>())
            ..loadClients(),
        ),
      ],
      child: Builder(builder: (newContext) {
        return Consumer<MainBLoC>(
          builder: (context, bloc, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              // theme: bloc.currentTheme == null
              //     ? ThemeData.light()
              //     : bloc.currentTheme,
              home: SplashScreen.init(newContext),
            );
          },
        );
      }),
    );
  }
}
