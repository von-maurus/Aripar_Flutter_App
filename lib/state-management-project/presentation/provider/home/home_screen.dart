import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/clientes/clientes_screen.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/preventas/preventas_page.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/productos/productos_screen.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/userprofile/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/state-management-project/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/provider/home/home_bloc.dart';
import 'package:arturo_bruna_app/state-management-project/presentation/common/theme.dart';

class HomePage extends StatelessWidget {
  HomePage._();

  static Widget init(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeBLoC(
            apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
            localRepositoryInterface: context.read<LocalRepositoryInterface>(),
          )..loadUser(),
          builder: (_, __) => HomePage._(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeBLoC>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: IndexedStack(
              index: bloc.indexSelected,
              children: [
                ProductosScreen.init(context),
                ClientesScreen.init(context),
                const Placeholder() ?? PreVentasPage(),
                UserScreen.init(context)
              ],
            ),
          ),
          _DeliveryNavigationBar(
            index: bloc.indexSelected,
            onIndexSelected: (index) {
              bloc.updateIndexSelected(index);
            },
          ),
        ],
      ),
    );
  }
}

class _DeliveryNavigationBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onIndexSelected;

  const _DeliveryNavigationBar({Key key, this.index, this.onIndexSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeBLoC>(context);
    // final cartBloc = Provider.of<PreVentaBLoC>(context);
    final user = bloc.usuario;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.orange[500],
          border: Border.all(
            color: Colors.orange[500],
            width: 2,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                color: Colors.orange[500],
                child: IconButton(
                  icon: Icon(
                    Icons.store_mall_directory,
                    color: index == 0
                        ? DeliveryColors.white
                        : Colors.teal.shade800,
                  ),
                  onPressed: () => onIndexSelected(0),
                ),
              ),
              Material(
                color: Colors.orange[500],
                child: IconButton(
                  icon: Icon(
                    Icons.people,
                    color: index == 1
                        ? DeliveryColors.white
                        : Colors.teal.shade800,
                  ),
                  onPressed: () => onIndexSelected(1),
                ),
              ),
              Material(
                color: Colors.orange[500],
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue[900],
                      radius: 25,
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_basket,
                          size: 32.0,
                          color: index == 2
                              ? DeliveryColors.white
                              : Colors.teal.shade200,
                        ),
                        onPressed: () => onIndexSelected(2),
                      ),
                    ),
                    // Positioned(
                    //   right: 0,
                    //   child: cartBloc.totalItems == 0
                    //       ? const SizedBox.shrink()
                    //       : CircleAvatar(
                    //     radius: 10,
                    //     backgroundColor: Colors.pinkAccent,
                    //     child: Text(
                    //       cartBloc.totalItems.toString(),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              SizedBox(
                width: 35,
              ),
              InkWell(
                onTap: () => onIndexSelected(3),
                child: user?.imagen == null
                    ? const SizedBox()
                    : CircleAvatar(
                        radius: 26.5,
                        backgroundImage: NetworkImage(
                          user.imagen,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}