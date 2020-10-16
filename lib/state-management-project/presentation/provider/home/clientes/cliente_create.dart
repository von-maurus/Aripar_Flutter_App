import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/clientes_bloc.dart';

class ClientCreate extends StatelessWidget {
  ClientCreate._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientesBLoC(
          apiRepositoryInterface: context.read<ApiRepositoryInterface>()),
      builder: (_, __) => ClientCreate._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientsBloc = context.watch<ClientesBLoC>();
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
