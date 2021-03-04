import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file:///C:/Development/fernando-herrera/flutter-advance/arturo_bruna_app/lib/main_bloc.dart';

import 'file:///C:/Development/fernando-herrera/flutter-advance/arturo_bruna_app/lib/data/api_repository_impl.dart';
import 'file:///C:/Development/fernando-herrera/flutter-advance/arturo_bruna_app/lib/data/local_repository_impl.dart';
import 'file:///C:/Development/fernando-herrera/flutter-advance/arturo_bruna_app/lib/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/splash/splash_screen.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/productos/productos_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/preventas/preventas_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/clientes_bloc.dart';

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