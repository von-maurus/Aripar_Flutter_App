import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/data/api_repository_impl.dart';
import 'package:arturo_bruna_app/data/local_repository_impl.dart';
import 'package:arturo_bruna_app/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/presentation/main_bloc.dart';
import 'package:arturo_bruna_app/presentation/home/clientes/clientes_bloc.dart';
import 'package:arturo_bruna_app/presentation/home/preventas/preventas_bloc.dart';
import 'package:arturo_bruna_app/presentation/home/productos/productos_bloc.dart';
import 'package:arturo_bruna_app/presentation/splash/splash_screen.dart';

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
        ChangeNotifierProvider(
          create: (context) => PreSaleBLoC(
            apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
            localRepositoryInterface: context.read<LocalRepositoryInterface>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductosBLoC(
            apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
            localRepositoryInterface: context.read<LocalRepositoryInterface>(),
          ),
        )
      ],
      child: Builder(
        builder: (newContext) {
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
        },
      ),
    );
  }
}
